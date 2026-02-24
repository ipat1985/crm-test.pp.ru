<template>
  <div class="input-textfield-custom" :class="fieldClass" @click="$emit('click', $event)">
    <label class="input-textfield-custom__control" :for="inputId">
      <div class="input-textfield-custom__inner">
        <slot name="prepend">
          <q-icon v-if="leadingIcon" :name="leadingIcon" class="input-textfield-custom__icon" />
        </slot>

        <div class="input-textfield-custom__content">
          <span
            v-if="label"
            class="input-textfield-custom__label"
            :class="{ 'input-textfield-custom__label--float': isFloating }"
          >
            {{ label }}
          </span>

          <textarea
            v-if="type === 'textarea'"
            :id="inputId"
            ref="textareaEl"
            class="input-textfield-custom__native input-textfield-custom__native--textarea"
            :placeholder="showPlaceholder ? placeholder : ''"
            :disabled="disabled"
            :readonly="readonly"
            :maxlength="maxlength"
            :value="stringValue"
            @input="onInput"
            @focus="onFocus"
            @blur="onBlur"
          />
          <input
            v-else
            :id="inputId"
            ref="inputEl"
            class="input-textfield-custom__native"
            :type="inputType"
            :placeholder="showPlaceholder ? placeholder : ''"
            :disabled="disabled"
            :readonly="readonly"
            :maxlength="maxlength"
            :inputmode="inputmode"
            :value="stringValue"
            @input="onInput"
            @focus="onFocus"
            @blur="onBlur"
          />
        </div>

        <slot name="append">
          <q-icon v-if="trailingIcon" :name="trailingIcon" class="input-textfield-custom__icon" />
        </slot>
      </div>
    </label>

    <div
      v-if="showHelper && (helperText || (error && errorMessage))"
      class="input-textfield-custom__helper"
      :class="{ 'input-textfield-custom__helper--error': error }"
    >
      {{ error && errorMessage ? errorMessage : helperText }}
    </div>
    <div v-else-if="counter && maxlength != null" class="input-textfield-custom__counter">
      {{ stringValue.length }}/{{ maxlength }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, ref, watch } from 'vue';

defineOptions({ name: 'InputTextfieldCustom' });

const props = withDefaults(
  defineProps<{
    modelValue?: string | number | null;
    label?: string;
    placeholder?: string;
    helperText?: string;
    error?: boolean;
    errorMessage?: string;
    disabled?: boolean;
    readonly?: boolean;
    maxlength?: number;
    counter?: boolean;
    type?: 'text' | 'textarea' | 'password' | 'search' | 'tel' | 'url' | 'email' | 'number';
    inputmode?: 'none' | 'text' | 'tel' | 'url' | 'email' | 'numeric' | 'decimal' | 'search';
    leadingIcon?: string;
    trailingIcon?: string;
    forceFocused?: boolean;
    autoGrow?: boolean;
    minRows?: number;
    maxRows?: number;
  }>(),
  {
    modelValue: '',
    label: '',
    placeholder: '',
    helperText: '',
    error: false,
    errorMessage: '',
    disabled: false,
    readonly: false,
    counter: false,
    type: 'text',
    leadingIcon: '',
    trailingIcon: '',
    forceFocused: false,
    autoGrow: false,
    minRows: 1,
    maxRows: 5,
  },
);

const emit = defineEmits<{
  'update:modelValue': [value: string | number | null];
  focus: [event: Event];
  blur: [event: Event];
  click: [event: Event];
}>();

const inputEl = ref<HTMLInputElement | null>(null);
const textareaEl = ref<HTMLTextAreaElement | null>(null);
const isFocused = ref(false);
const inputId = `itc_${Math.random().toString(36).slice(2)}`;

const stringValue = computed(() => String(props.modelValue ?? ''));
const isFloating = computed(() => isFocused.value || props.forceFocused || stringValue.value.length > 0);
const showPlaceholder = computed(() => isFloating.value || !props.label);
const showHelper = computed(() => Boolean(props.helperText || (props.error && props.errorMessage)));
const inputType = computed(() => (props.type === 'textarea' ? 'text' : props.type));

const fieldClass = computed(() => ({
  'input-textfield-custom--error': props.error,
  'input-textfield-custom--disabled': props.disabled,
  'input-textfield-custom--focused': isFocused.value || props.forceFocused,
  'input-textfield-custom--floating': isFloating.value,
}));

function onInput(event: Event): void {
  const target = event.target as HTMLInputElement | HTMLTextAreaElement | null;
  emit('update:modelValue', target?.value ?? '');

  if (props.type === 'textarea' && props.autoGrow) {
    resizeTextarea();
  }
}

function onFocus(event: Event): void {
  isFocused.value = true;
  emit('focus', event);
}

function onBlur(event: Event): void {
  isFocused.value = false;
  emit('blur', event);
}

defineExpose({
  focus: () => {
    if (props.type === 'textarea') textareaEl.value?.focus();
    else inputEl.value?.focus();
  },
});

function resizeTextarea(): void {
  const textarea = textareaEl.value;
  if (!textarea || props.type !== 'textarea' || !props.autoGrow) return;

  const styles = window.getComputedStyle(textarea);
  const lineHeight = Number.parseFloat(styles.lineHeight) || 20;
  const minHeight = lineHeight * Math.max(props.minRows, 1);
  const maxHeight = lineHeight * Math.max(props.maxRows, 1);

  textarea.style.height = 'auto';
  const nextHeight = Math.max(minHeight, Math.min(textarea.scrollHeight, maxHeight));
  textarea.style.height = `${nextHeight}px`;
  textarea.style.overflowY = textarea.scrollHeight > maxHeight ? 'auto' : 'hidden';
}

onMounted(() => {
  if (props.type === 'textarea' && props.autoGrow) {
    void nextTick(() => resizeTextarea());
  }
});

watch(
  () => props.modelValue,
  () => {
    if (props.type === 'textarea' && props.autoGrow) {
      void nextTick(() => resizeTextarea());
    }
  },
);
</script>

<style scoped lang="scss">
.input-textfield-custom {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.input-textfield-custom__control {
  min-height: 56px;
  border: 1px solid var(--input-border-color, #2f2b3d38);
  border-radius: 8px;
  padding: 6px 12px;
  background: var(--color-bg-white);
  box-sizing: border-box;
  width: 100%;
  display: flex;
  align-items: center;
  transition: border-color 0.2s ease;
  cursor: text;
}

.input-textfield-custom--focused .input-textfield-custom__control {
  border-color: var(--color-primary-main);
}

.input-textfield-custom--error .input-textfield-custom__control {
  border-color: var(--input-border-color-error);
}

.input-textfield-custom__label {
  display: block;
  font-family: var(--font-family-roboto);
  color: var(--color-text-secondary);
  font-size: 16px;
  line-height: 20px;
  transform-origin: left top;
  transition: color 0.2s ease, transform 0.2s ease, font-size 0.2s ease;
}

.input-textfield-custom__label--float {
  font-size: 14px;
  color: var(--color-primary-main);
}

.input-textfield-custom--focused .input-textfield-custom__label {
  color: var(--color-primary-main);
}

.input-textfield-custom--error .input-textfield-custom__label {
  color: var(--input-border-color-error);
}

.input-textfield-custom__inner {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 12px;
}

.input-textfield-custom__icon {
  color: var(--color-text-secondary);
  font-size: 24px;
  flex-shrink: 0;
}

.input-textfield-custom__content {
  width: 100%;
  min-width: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 0;
}

.input-textfield-custom__native {
  width: 100%;
  border: 0;
  outline: 0;
  background: transparent;
  font-family: var(--font-family-roboto);
  color: var(--color-text-primary);
  font-size: 16px;
  line-height: 20px;
  padding: 0;
  height: 0;
  opacity: 0;
  pointer-events: none;
}

.input-textfield-custom__native::placeholder {
  color: var(--color-text-secondary);
  opacity: 1;
}

.input-textfield-custom__native--textarea {
  min-height: 20px;
  resize: none;
  opacity: 1;
  pointer-events: auto;
  overflow-y: hidden;
}

.input-textfield-custom--floating .input-textfield-custom__content {
  justify-content: space-between;
}

.input-textfield-custom--floating .input-textfield-custom__native {
  height: 20px;
  padding-top: 2px;
  opacity: 1;
  pointer-events: auto;
}

.input-textfield-custom--disabled {
  opacity: 0.7;
}

.input-textfield-custom--disabled .input-textfield-custom__control {
  cursor: not-allowed;
}

.input-textfield-custom--disabled .input-textfield-custom__native {
  cursor: not-allowed;
}

.input-textfield-custom__helper,
.input-textfield-custom__counter {
  padding-top: 8px;
  font-size: 12px;
  line-height: 12px;
  color: var(--color-text-secondary);
}

.input-textfield-custom__helper--error,
.input-textfield-custom--error .input-textfield-custom__helper {
  color: var(--input-border-color-error);
}
</style>
