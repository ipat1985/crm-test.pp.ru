<template>
  <div class="text-field" :class="fieldClass">
    <label v-if="label" class="text-field__label">
      {{ label }}
      <span v-if="required" class="text-field__required" aria-hidden="true">*</span>
    </label>
    <q-input
      ref="inputRef"
      :model-value="modelValue"
      :placeholder="placeholder"
      :disabled="disabled"
      :readonly="readonly"
      :error="error"
      :maxlength="maxlength"
      outlined
      dense
      class="text-field__input"
      :borderless="false"
      v-bind="$attrs"
      @update:model-value="$emit('update:modelValue', $event)"
    >
      <template v-if="$slots.prepend" #prepend>
        <slot name="prepend" />
      </template>
      <template v-if="$slots.append" #append>
        <slot name="append" />
      </template>
    </q-input>
    <div
      v-if="showHelper && (helperText || (error && errorMessage))"
      class="text-field__helper"
      :class="{ 'text-field__helper--error': error }"
    >
      {{ error && errorMessage ? errorMessage : helperText }}
    </div>
    <div
      v-else-if="counter && maxlength != null"
      class="text-field__counter"
    >
      {{ String(modelValue ?? '').length }}/{{ maxlength }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import type { ComponentPublicInstance } from 'vue';

defineOptions({ name: 'TextField' });

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
    required?: boolean;
    maxlength?: number;
    counter?: boolean;
  }>(),
  {
    modelValue: '',
    required: false,
    counter: false,
  },
);

defineEmits<{
  'update:modelValue': [value: string | number | null];
}>();

const inputRef = ref<(ComponentPublicInstance & { focus?: () => void }) | null>(null);

const showHelper = computed(
  () => Boolean(props.helperText || (props.error && props.errorMessage)),
);

const fieldClass = computed(() => ({
  'text-field--error': props.error,
  'text-field--disabled': props.disabled,
}));

defineExpose({
  inputRef,
  focus: () => inputRef.value?.focus?.(),
});
</script>

<style scoped lang="scss">
.text-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
  width: 100%;
}

.text-field__label {
  font-size: var(--input-label-font-size);
  line-height: 1.4;
  color: var(--input-label-color);
  font-weight: 500;
}

.text-field--error .text-field__label {
  color: var(--input-label-color-error);
}

.text-field--disabled .text-field__label {
  color: var(--input-disabled-color);
  opacity: var(--input-disabled-opacity);
}

.text-field__required {
  color: var(--input-border-color-error);
  margin-left: 2px;
}

.text-field__input {
  --q-field-border-color: var(--input-border-color);
  --q-field-label-color: var(--input-label-color);
  --q-field-focused-border-color: var(--input-border-color-focus);
  --q-field-hover-border-color: var(--input-border-color);
}

.text-field__input :deep(.q-field__control) {
  height: var(--input-height);
  padding-left: var(--input-padding-x);
  padding-right: var(--input-padding-x);
  border-radius: var(--input-border-radius);
  background: var(--input-bg);
}

.text-field__input :deep(.q-field__control::before) {
  border-width: var(--input-border-width);
  border-color: var(--input-border-color);
  border-radius: var(--input-border-radius);
}

.text-field__input :deep(.q-field--focused .q-field__control::before) {
  border-color: var(--input-border-color-focus);
}

.text-field--error .text-field__input :deep(.q-field__control::before),
.text-field__input :deep(.q-field--error .q-field__control::before) {
  border-color: var(--input-border-color-error);
}

.text-field__input :deep(.q-field__native) {
  color: var(--input-text-color);
  font-size: 14px;
}

.text-field__input :deep(.q-field__native::placeholder) {
  color: var(--input-placeholder-color);
}

.text-field--disabled .text-field__input :deep(.q-field__control) {
  background: var(--input-disabled-bg);
  opacity: var(--input-disabled-opacity);
}

.text-field__input :deep(.q-field__prepend) .q-icon,
.text-field__input :deep(.q-field__append) .q-icon {
  font-size: var(--input-icon-size);
  color: var(--input-icon-color);
}

.text-field__helper,
.text-field__counter {
  font-size: var(--input-helper-font-size);
  line-height: 1.4;
  color: var(--input-helper-color);
}

.text-field__helper--error,
.text-field--error .text-field__helper {
  color: var(--input-helper-color-error);
}

.text-field__input :deep(.q-field__bottom) {
  display: none; /* используем свой helper/counter */
}
</style>
