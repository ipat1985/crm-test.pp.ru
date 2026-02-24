<template>
  <div
    class="input-select-custom"
    :class="[
      fieldClass,
      { 'input-select-custom--opened': opened },
      { 'input-select-custom--floating': isFloating },
    ]"
  >
    <div
      ref="anchorRef"
      class="input-select-custom__control"
      tabindex="0"
      role="button"
      @click="toggleMenu"
      @keydown.enter.prevent="toggleMenu"
      @keydown.space.prevent="toggleMenu"
      @focus="onFocus"
      @blur="onBlur"
    >
      <slot name="prepend">
        <q-icon v-if="leadingIcon" :name="leadingIcon" class="input-select-custom__icon" />
      </slot>

      <div class="input-select-custom__content">
        <span v-if="label" class="input-select-custom__label" :class="{ 'input-select-custom__label--float': isFloating }">
          {{ label }}
        </span>
        <span v-if="isFloating && displayValue" class="input-select-custom__value">{{ displayValue }}</span>
      </div>

      <slot name="append">
        <q-icon
          v-if="clearable && hasValue && !disabled && !readonly"
          name="o_close"
          class="input-select-custom__icon input-select-custom__clear"
          @click.stop="clearValue"
        />
        <q-icon
          name="o_expand_more"
          class="input-select-custom__icon input-select-custom__arrow"
          :class="{ 'input-select-custom__arrow--opened': opened }"
        />
      </slot>
    </div>

    <q-menu
      v-model="opened"
      :target="menuTarget"
      anchor="bottom left"
      self="top left"
      :offset="[0, 8]"
      fit
      no-parent-event
      class="input-select-custom__menu"
    >
      <div class="input-select-custom__menu-list">
        <button
          v-for="option in normalizedOptions"
          :key="String(option.value)"
          type="button"
          class="input-select-custom__option"
          :class="{ 'input-select-custom__option--active': option.value === modelValue }"
          @click="selectOption(option.value)"
        >
          {{ option.label }}
        </button>
      </div>
    </q-menu>

    <div
      v-if="showHelper && (helperText || (error && errorMessage))"
      class="input-select-custom__helper"
      :class="{ 'input-select-custom__helper--error': error }"
    >
      {{ error && errorMessage ? errorMessage : helperText }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';

defineOptions({ name: 'InputSelectCustom' });

type SelectOptionValue = string | number;
type RawOption = Record<string, unknown>;
interface NormalizedOption {
  label: string;
  value: SelectOptionValue;
}

const props = withDefaults(
  defineProps<{
    modelValue?: SelectOptionValue | null;
    options: RawOption[];
    label?: string;
    helperText?: string;
    error?: boolean;
    errorMessage?: string;
    disabled?: boolean;
    readonly?: boolean;
    clearable?: boolean;
    leadingIcon?: string;
    optionLabel?: string;
    optionValue?: string;
  }>(),
  {
    modelValue: null,
    label: 'Label',
    helperText: '',
    error: false,
    errorMessage: '',
    disabled: false,
    readonly: false,
    clearable: true,
    leadingIcon: '',
    optionLabel: 'label',
    optionValue: 'value',
  },
);

const emit = defineEmits<{
  'update:modelValue': [value: SelectOptionValue | null];
  focus: [event: Event];
  blur: [event: Event];
}>();

const opened = ref(false);
const isFocused = ref(false);
const anchorRef = ref<HTMLElement | null>(null);
const menuTarget = computed<Element | undefined>(() => anchorRef.value ?? undefined);

const normalizedOptions = computed<NormalizedOption[]>(() =>
  props.options
    .map((option) => {
      const label = option[props.optionLabel];
      const value = option[props.optionValue];
      if ((typeof value !== 'string' && typeof value !== 'number') || typeof label !== 'string') return null;
      return { label, value };
    })
    .filter((o): o is NormalizedOption => o !== null),
);

const hasValue = computed(() => props.modelValue !== null && props.modelValue !== undefined && String(props.modelValue) !== '');
const displayValue = computed(
  () => normalizedOptions.value.find((o) => o.value === props.modelValue)?.label ?? '',
);
const isFloating = computed(() => opened.value || isFocused.value || hasValue.value);
const showHelper = computed(() => Boolean(props.helperText || (props.error && props.errorMessage)));

const fieldClass = computed(() => ({
  'input-select-custom--error': props.error,
  'input-select-custom--disabled': props.disabled,
}));

function toggleMenu(): void {
  if (props.disabled || props.readonly) return;
  opened.value = !opened.value;
}

function selectOption(value: SelectOptionValue): void {
  emit('update:modelValue', value);
  opened.value = false;
}

function clearValue(): void {
  emit('update:modelValue', null);
}

function onFocus(event: Event): void {
  isFocused.value = true;
  emit('focus', event);
}

function onBlur(event: Event): void {
  isFocused.value = false;
  emit('blur', event);
}
</script>

<style scoped lang="scss">
.input-select-custom {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.input-select-custom__control {
  min-height: 56px;
  border: 1px solid var(--input-border-color, #2f2b3d38);
  border-radius: 8px;
  padding: 6px 12px;
  background: var(--color-bg-white);
  box-sizing: border-box;
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  transition: border-color 0.2s ease;
}

.input-select-custom--opened .input-select-custom__control,
.input-select-custom__control:focus-visible {
  border-color: var(--color-primary-main);
  outline: none;
}

.input-select-custom--error .input-select-custom__control {
  border-color: var(--input-border-color-error);
}

.input-select-custom__content {
  width: 100%;
  min-width: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.input-select-custom--floating .input-select-custom__content {
  justify-content: space-between;
}

.input-select-custom__label {
  font-family: var(--font-family-roboto);
  color: var(--color-text-secondary);
  font-size: 16px;
  line-height: 20px;
  transition: color 0.2s ease, font-size 0.2s ease;
}

.input-select-custom__label--float {
  font-size: 14px;
  color: var(--color-primary-main);
}

.input-select-custom__value {
  font-family: var(--font-family-roboto);
  color: var(--color-text-primary);
  font-size: 16px;
  line-height: 20px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.input-select-custom__icon {
  color: var(--color-text-secondary);
  font-size: 20px;
  flex-shrink: 0;
}

.input-select-custom__arrow {
  transition: transform 0.2s ease;
}

.input-select-custom__arrow--opened {
  transform: rotate(180deg);
}

.input-select-custom--disabled {
  opacity: 0.7;
}

.input-select-custom__menu {
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid var(--input-border-color, #2f2b3d38);
}

.input-select-custom__menu-list {
  display: flex;
  flex-direction: column;
  min-width: 180px;
  background: var(--color-bg-white);
}

.input-select-custom__option {
  border: 0;
  background: transparent;
  text-align: left;
  padding: 10px 12px;
  font-family: var(--font-family-roboto);
  font-size: 16px;
  line-height: 20px;
  color: var(--color-text-primary);
  cursor: pointer;
}

.input-select-custom__option:hover {
  background: var(--color-primary-o-light);
}

.input-select-custom__option--active {
  color: var(--color-primary-main);
}

.input-select-custom__helper {
  padding-top: 8px;
  font-size: 12px;
  line-height: 12px;
  color: var(--color-text-secondary);
}

.input-select-custom__helper--error {
  color: var(--input-border-color-error);
}
</style>
