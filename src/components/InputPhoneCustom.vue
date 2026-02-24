<template>
  <div class="input-phone-custom" :class="fieldClass">
    <label class="input-phone-custom__control" @click="onControlClick">
      <div class="input-phone-custom__inner">
        <div class="input-phone-custom__content">
          <span class="input-phone-custom__label" :class="{ 'input-phone-custom__label--float': isFloating }">
            {{ label }}
          </span>

          <div v-if="isFloating" class="input-phone-custom__mask">
            <input
              ref="inputRef"
              class="input-phone-custom__native"
              inputmode="numeric"
              :value="displayValue"
              @focus="onFocus"
              @blur="onBlur"
              @click="onInputClick"
              @keydown="onKeydown"
              @input="onNativeInput"
            />

            <span class="input-phone-custom__visual" aria-hidden="true">
              <span
                v-for="(char, index) in visualChars"
                :key="`${index}-${char.value}`"
                class="input-phone-custom__char"
                :class="`input-phone-custom__char--${char.type}`"
              >
                {{ char.value }}
              </span>
            </span>
          </div>
        </div>

        <q-icon
          v-if="hasAnyDigit && !disabled"
          name="o_close"
          class="input-phone-custom__clear"
          @click.stop="clearAll"
        />
      </div>
    </label>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, ref, watch } from 'vue';

defineOptions({ name: 'InputPhoneCustom' });

const MASK_TEMPLATE = '+7 (000) 000-00-00';
const EDITABLE_POSITIONS = [4, 5, 6, 9, 10, 11, 13, 14, 16, 17] as const;
const FIRST_EDITABLE_POSITION = 4;
const LAST_EDITABLE_POSITION = 17;

type EditablePos = (typeof EDITABLE_POSITIONS)[number];
type MaskCharType = 'static' | 'placeholder' | 'filled';

const props = withDefaults(
  defineProps<{
    modelValue?: string;
    label?: string;
    disabled?: boolean;
  }>(),
  {
    modelValue: '',
    label: 'Телефон',
    disabled: false,
  },
);

const emit = defineEmits<{
  'update:modelValue': [value: string];
}>();

const inputRef = ref<HTMLInputElement | null>(null);
const isFocused = ref(false);
const digits = ref<(string | null)[]>(Array(10).fill(null));

const hasAnyDigit = computed(() => digits.value.some((digit) => digit !== null));
const isFloating = computed(() => isFocused.value || hasAnyDigit.value);
const digitsValue = computed(() => digits.value.map((digit) => digit ?? '').join(''));
const displayValue = computed(() =>
  charsFromDigits(digits.value)
    .map((char) => char.value)
    .join(''),
);
const visualChars = computed(() => charsFromDigits(digits.value));

const fieldClass = computed(() => ({
  'input-phone-custom--focused': isFocused.value,
  'input-phone-custom--disabled': props.disabled,
}));

watch(
  () => props.modelValue,
  (value) => {
    const normalized = String(value ?? '')
      .replace(/\D/g, '')
      .slice(0, 10)
      .split('');
    digits.value = Array.from({ length: 10 }, (_, index) => normalized[index] ?? null);
  },
  { immediate: true },
);

watch(digitsValue, (value) => {
  emit('update:modelValue', value);
});

function charsFromDigits(source: (string | null)[]): Array<{ value: string; type: MaskCharType }> {
  const chars = MASK_TEMPLATE.split('');
  return chars.map((char, index) => {
    const editableIndex = EDITABLE_POSITIONS.indexOf(index as EditablePos);
    if (editableIndex === -1) {
      return { value: char, type: 'static' as const };
    }

    const digit = source[editableIndex];
    return { value: digit ?? '0', type: digit === null ? ('placeholder' as const) : ('filled' as const) };
  });
}

function onControlClick(event: MouseEvent): void {
  if (props.disabled) return;
  if (event.target instanceof HTMLElement && event.target.classList.contains('input-phone-custom__clear')) return;
  isFocused.value = true;
  void nextTick(() => {
    inputRef.value?.focus();
    if (!hasAnyDigit.value) {
      setCaret(nextEditablePosition(0));
    }
  });
}

function onFocus(): void {
  if (props.disabled) return;
  isFocused.value = true;
  void nextTick(() => {
    if (!hasAnyDigit.value) setCaret(nextEditablePosition(0));
  });
}

function onBlur(): void {
  isFocused.value = false;
}

function onInputClick(): void {
  snapCaretToEditable();
}

function onNativeInput(): void {
  // Prevent browser from diverging native value from our mask-rendered state.
  void nextTick(() => {
    if (inputRef.value) inputRef.value.value = displayValue.value;
  });
}

function onKeydown(event: KeyboardEvent): void {
  if (props.disabled) return;

  const input = inputRef.value;
  if (!input) return;

  const start = input.selectionStart ?? 0;
  const end = input.selectionEnd ?? start;

  if (event.key >= '0' && event.key <= '9') {
    event.preventDefault();
    writeDigit(event.key, start, end);
    return;
  }

  if (event.key === 'Backspace') {
    event.preventDefault();
    removeDigitBackward(start, end);
    return;
  }

  if (event.key === 'Delete') {
    event.preventDefault();
    removeDigitForward(start, end);
    return;
  }

  if (event.key === 'Home') {
    event.preventDefault();
    setCaret(nextEditablePosition(0));
    return;
  }

  if (event.key === 'End') {
    event.preventDefault();
    setCaret(previousEditablePosition(MASK_TEMPLATE.length));
    return;
  }

  // Allow arrows/navigation/modifier shortcuts.
  if (
    event.key === 'ArrowLeft' ||
    event.key === 'ArrowRight' ||
    event.key === 'Tab' ||
    event.key === 'Shift' ||
    event.key === 'Control' ||
    event.key === 'Meta' ||
    event.key === 'Alt'
  ) {
    void nextTick(() => snapCaretToEditable());
    return;
  }

  if (event.ctrlKey || event.metaKey) return;

  event.preventDefault();
}

function writeDigit(digit: string, start: number, end: number): void {
  if (start !== end) {
    clearRange(start, end);
  }

  const editablePos = nextEditablePosition(start);
  const digitIndex = editableIndexFromPosition(editablePos);
  if (digitIndex < 0) return;

  digits.value[digitIndex] = digit;

  void nextTick(() => {
    if (editablePos === LAST_EDITABLE_POSITION) {
      setCaret(MASK_TEMPLATE.length);
      return;
    }
    setCaret(nextEditablePosition(editablePos + 1));
  });
}

function removeDigitBackward(start: number, end: number): void {
  if (start !== end) {
    clearRange(start, end);
    void nextTick(() => setCaret(nextEditablePosition(start)));
    return;
  }

  const editablePos = previousEditablePosition(start);
  const digitIndex = editableIndexFromPosition(editablePos);
  if (digitIndex < 0) return;

  digits.value[digitIndex] = null;
  void nextTick(() => setCaret(editablePos));
}

function removeDigitForward(start: number, end: number): void {
  if (start !== end) {
    clearRange(start, end);
    void nextTick(() => setCaret(nextEditablePosition(start)));
    return;
  }

  const editablePos = nextEditablePosition(start);
  const digitIndex = editableIndexFromPosition(editablePos);
  if (digitIndex < 0) return;

  digits.value[digitIndex] = null;
  void nextTick(() => setCaret(editablePos));
}

function clearRange(start: number, end: number): void {
  EDITABLE_POSITIONS.forEach((position, index) => {
    if (position >= start && position < end) {
      digits.value[index] = null;
    }
  });
}

function clearAll(): void {
  digits.value = Array(10).fill(null);
  void nextTick(() => {
    inputRef.value?.focus();
    setCaret(nextEditablePosition(0));
  });
}

function editableIndexFromPosition(position: number): number {
  return EDITABLE_POSITIONS.indexOf(position as EditablePos);
}

function nextEditablePosition(position: number): number {
  for (const item of EDITABLE_POSITIONS) {
    if (item >= position) return item;
  }
  return LAST_EDITABLE_POSITION;
}

function previousEditablePosition(position: number): number {
  for (let i = EDITABLE_POSITIONS.length - 1; i >= 0; i -= 1) {
    const candidate = EDITABLE_POSITIONS[i];
    if (candidate !== undefined && candidate < position) return candidate;
  }
  return FIRST_EDITABLE_POSITION;
}

function setCaret(position: number): void {
  const input = inputRef.value;
  if (!input) return;
  input.setSelectionRange(position, position);
}

function snapCaretToEditable(): void {
  const input = inputRef.value;
  if (!input) return;

  const start = input.selectionStart ?? 0;
  const end = input.selectionEnd ?? start;
  if (start !== end) return;

  if (editableIndexFromPosition(start) !== -1) return;

  const next = nextEditablePosition(start);
  const prev = previousEditablePosition(start);
  const nearest = Math.abs(next - start) < Math.abs(start - prev) ? next : prev;
  setCaret(nearest);
}
</script>

<style scoped lang="scss">
.input-phone-custom {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.input-phone-custom__control {
  min-height: 56px;
  border: 1px solid var(--input-border-color, #2f2b3d38);
  border-radius: 8px;
  padding: 6px 12px;
  background: var(--color-bg-white);
  box-sizing: border-box;
  width: 100%;
  display: flex;
  align-items: center;
  cursor: text;
  transition: border-color 0.2s ease;
}

.input-phone-custom--focused .input-phone-custom__control {
  border-color: var(--color-primary-main);
}

.input-phone-custom__inner {
  width: 100%;
  display: flex;
  align-items: center;
}

.input-phone-custom__content {
  width: 100%;
  min-width: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.input-phone-custom__label {
  display: block;
  font-family: var(--font-family-roboto);
  color: var(--color-text-secondary);
  font-size: 16px;
  line-height: 20px;
  transition: color 0.2s ease, font-size 0.2s ease;
}

.input-phone-custom__label--float {
  font-size: 14px;
  color: var(--color-primary-main);
}

.input-phone-custom--focused .input-phone-custom__label {
  color: var(--color-primary-main);
}

.input-phone-custom__mask {
  position: relative;
  width: fit-content;
  padding-top: 2px;
}

.input-phone-custom__native,
.input-phone-custom__visual {
  font-family: var(--font-family-roboto);
  font-size: 16px;
  line-height: 20px;
  letter-spacing: 0;
  font-variant-numeric: tabular-nums;
}

.input-phone-custom__native {
  position: relative;
  z-index: 2;
  border: 0;
  outline: 0;
  background: transparent;
  padding: 0;
  margin: 0;
  width: 18ch;
  color: transparent !important;
  -webkit-text-fill-color: transparent;
  caret-color: var(--color-text-primary);
  text-shadow: none;
}

.input-phone-custom--disabled {
  opacity: 0.7;
}

.input-phone-custom--disabled .input-phone-custom__control,
.input-phone-custom--disabled .input-phone-custom__native {
  cursor: not-allowed;
}

.input-phone-custom__visual {
  position: absolute;
  inset: 0 auto auto 0;
  z-index: 1;
  pointer-events: none;
  white-space: pre;
}

.input-phone-custom__char {
  color: var(--color-text-disabled);
}

.input-phone-custom__char--static,
.input-phone-custom__char--filled {
  color: var(--color-text-primary) !important;
}

.input-phone-custom__char--placeholder {
  color: var(--color-text-primary) !important;
  opacity: 0.38;
}

.input-phone-custom__clear {
  color: var(--color-text-secondary);
  font-size: 20px;
  cursor: pointer;
  flex-shrink: 0;
}
</style>
