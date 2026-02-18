<template>
  <label
    class="checkbox"
    :class="[
      { 'checkbox--dense': dense },
      { 'checkbox--hover': state === 'hover' },
      { 'checkbox--disabled': isDisabled },
      { 'checkbox--rtl': rtl },
      { 'checkbox--flip': flip },
    ]"
  >
    <input
      class="checkbox__native"
      type="checkbox"
      :checked="isChecked"
      :disabled="isDisabled"
      @change="onChange"
    />

    <CheckboxIndicator
      class="checkbox__indicator"
      :checked="isChecked"
      :indeterminate="indeterminate"
      :dense="dense"
      :size="size"
      :state="isDisabled ? 'disabled' : state"
    />

    <span class="checkbox__content">
      <span class="checkbox__label">{{ label }}</span>
      <span v-if="description" class="checkbox__description">{{ description }}</span>
    </span>
  </label>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import CheckboxIndicator from './CheckboxIndicator.vue';

defineOptions({ name: 'CheckboxField' });

const props = withDefaults(
  defineProps<{
    modelValue?: boolean;
    label?: string;
    description?: string;
    state?: 'default' | 'hover' | 'disabled';
    dense?: boolean;
    flip?: boolean;
    rtl?: boolean;
    indeterminate?: boolean;
    size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  }>(),
  {
    modelValue: false,
    label: 'Label',
    description: 'With description',
    state: 'default',
    dense: false,
    flip: false,
    rtl: false,
    indeterminate: false,
    size: 'md',
  },
);

const emit = defineEmits<{
  'update:modelValue': [value: boolean];
  change: [value: boolean, event: Event];
}>();

const isDisabled = computed(() => props.state === 'disabled');
const isChecked = computed(() => props.modelValue);

function onChange(event: Event): void {
  const target = event.target as HTMLInputElement | null;
  const next = Boolean(target?.checked);
  emit('update:modelValue', next);
  emit('change', next, event);
}
</script>

<style scoped lang="scss">
.checkbox {
  display: inline-flex;
  align-items: center;
  gap: var(--checkbox-gap);
  padding: var(--checkbox-padding-y) var(--checkbox-padding-x);
  cursor: pointer;
  user-select: none;
  box-sizing: border-box;

  &--dense {
    gap: var(--checkbox-gap-dense);
    padding: var(--checkbox-padding-y-dense) var(--checkbox-padding-x-dense);
  }

  &--hover {
    background: var(--checkbox-hover-bg);
  }

  &--disabled {
    opacity: var(--checkbox-disabled-opacity);
    cursor: not-allowed;
  }

  &--rtl {
    direction: rtl;
  }

  &--flip {
    flex-direction: row-reverse;
  }
}

.checkbox__native {
  position: absolute;
  opacity: 0;
  pointer-events: none;
}

.checkbox__indicator {
  flex-shrink: 0;
}

.checkbox__content {
  display: inline-flex;
  flex-direction: column;
  gap: 4px;
}

.checkbox__label {
  font-family: var(--font-family-primary);
  font-size: var(--checkbox-label-font-size);
  line-height: var(--checkbox-label-line-height);
  color: var(--checkbox-label-color);
}

.checkbox__description {
  font-family: var(--font-family-fa);
  font-size: var(--checkbox-description-font-size);
  line-height: var(--checkbox-description-line-height);
  color: var(--checkbox-description-color);
}
</style>
