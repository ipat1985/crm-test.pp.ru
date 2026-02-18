<template>
  <div class="select-field" :class="fieldClass">
    <q-select
      ref="selectRef"
      :model-value="modelValue"
      :options="options"
      :option-label="optionLabel"
      :option-value="optionValue"
      :placeholder="placeholder"
      :disable="disabled"
      :readonly="readonly"
      :error="error"
      :maxlength="maxlength"
      filled
      dense
      emit-value
      map-options
      options-dense
      class="select-field__input"
      popup-content-class="select-field__menu"
      v-bind="$attrs"
      @popup-show="opened = true"
      @popup-hide="opened = false"
      @update:model-value="$emit('update:modelValue', $event)"
    >
      <template #prepend>
        <slot name="prepend">
          <q-icon v-if="leadingIcon" :name="leadingIcon" />
        </slot>
      </template>

      <template #append>
        <slot name="append">
          <q-icon
            name="o_expand_more"
            class="select-field__arrow"
            :class="{ 'select-field__arrow--opened': opened }"
          />
        </slot>
      </template>

      <template #option="scope">
        <q-item v-bind="scope.itemProps" class="select-field__option">
          <q-item-section avatar v-if="scope.opt?.icon">
            <q-icon :name="scope.opt.icon" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ scope.opt?.[optionLabel] }}</q-item-label>
          </q-item-section>
        </q-item>
      </template>
    </q-select>

    <div
      v-if="showHelper && (helperText || (error && errorMessage))"
      class="select-field__helper"
      :class="{ 'select-field__helper--error': error }"
    >
      {{ error && errorMessage ? errorMessage : helperText }}
    </div>
    <div
      v-else-if="counter && maxlength != null"
      class="select-field__counter"
    >
      {{ String(modelValue ?? '').length }}/{{ maxlength }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import type { ComponentPublicInstance } from 'vue';

defineOptions({ name: 'SelectField' });

type SelectOptionValue = string | number;

interface SelectOption {
  label: string;
  value: SelectOptionValue;
  icon?: string;
}

const props = withDefaults(
  defineProps<{
    modelValue?: SelectOptionValue | null;
    options: SelectOption[];
    placeholder?: string;
    helperText?: string;
    error?: boolean;
    errorMessage?: string;
    disabled?: boolean;
    readonly?: boolean;
    maxlength?: number;
    counter?: boolean;
    leadingIcon?: string;
    optionLabel?: string;
    optionValue?: string;
  }>(),
  {
    modelValue: null,
    counter: false,
    placeholder: '',
    helperText: '',
    error: false,
    errorMessage: '',
    disabled: false,
    readonly: false,
    leadingIcon: 'o_info',
    optionLabel: 'label',
    optionValue: 'value',
  },
);

defineEmits<{
  'update:modelValue': [value: SelectOptionValue | null];
}>();

const selectRef = ref<(ComponentPublicInstance & { focus?: () => void }) | null>(null);
const opened = ref(false);

const showHelper = computed(
  () => Boolean(props.helperText || (props.error && props.errorMessage)),
);

const fieldClass = computed(() => ({
  'select-field--error': props.error,
  'select-field--disabled': props.disabled,
}));

defineExpose({
  selectRef,
  focus: () => selectRef.value?.focus?.(),
});
</script>

<style scoped lang="scss">
.select-field {
  display: flex;
  flex-direction: column;
  gap: 4px;
  width: 100%;
}

.select-field__input {
  --q-field-control-height: var(--select-height);
}

.select-field__input :deep(.q-field__control) {
  min-height: var(--select-height);
  padding-left: var(--select-padding-x);
  padding-right: var(--select-padding-x);
  border-radius: var(--select-border-radius) var(--select-border-radius) 0 0;
  background: var(--select-bg);
}

.select-field__input :deep(.q-field__control::before) {
  border-width: 0 0 var(--select-border-width) 0;
  border-color: var(--select-border-color);
}

.select-field__input :deep(.q-field__control:hover::before) {
  border-color: var(--select-border-color-focus);
}

.select-field__input :deep(.q-field--focused .q-field__control::before) {
  border-color: var(--select-border-color-focus);
}

.select-field--error .select-field__input :deep(.q-field__control::before),
.select-field__input :deep(.q-field--error .q-field__control::before) {
  border-color: var(--select-border-color-error);
}

.select-field__input :deep(.q-field__native),
.select-field__input :deep(.q-field__input) {
  color: var(--select-text-color);
  font-size: 16px;
}

.select-field__input :deep(.q-field__native span) {
  color: var(--select-text-color);
}

.select-field__input :deep(.q-field__native::placeholder),
.select-field__input :deep(.q-placeholder) {
  color: var(--select-placeholder-color);
}

.select-field--disabled .select-field__input :deep(.q-field__control) {
  opacity: var(--select-disabled-opacity);
}

.select-field__input :deep(.q-field__prepend) .q-icon,
.select-field__input :deep(.q-field__append) .q-icon {
  font-size: var(--select-icon-size);
  color: var(--select-icon-color);
}

.select-field__arrow {
  transition: transform 0.2s ease;
}

.select-field__arrow--opened {
  transform: rotate(180deg);
}

.select-field__helper,
.select-field__counter {
  font-size: var(--select-helper-font-size);
  line-height: 1.4;
  color: var(--select-helper-color);
}

.select-field__helper--error,
.select-field--error .select-field__helper {
  color: var(--select-helper-color-error);
}

.select-field__input :deep(.q-field__bottom) {
  display: none;
}

:global(.select-field__menu) {
  border: 1px solid var(--select-menu-border);
  border-radius: var(--select-menu-radius);
  overflow: hidden;
}

:global(.select-field__menu .q-item) {
  min-height: var(--select-option-height);
  color: var(--select-option-text-color);
}

:global(.select-field__menu .q-item__label) {
  font-size: 14px;
  line-height: 20px;
}
</style>
