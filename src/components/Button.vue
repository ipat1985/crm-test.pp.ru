<template>
  <button
    type="button"
    class="app-button"
    :class="[
      `app-button--${variant}`,
      `app-button--${size}`,
      { 'app-button--rounded': rounded },
      { 'app-button--loading': loading },
      { 'app-button--disabled': disabled },
    ]"
    :disabled="disabled || loading"
    @click="$emit('click', $event)"
  >
    <q-spinner v-if="loading" size="20px" class="app-button__spinner" />
    <q-icon v-else-if="icon && !loading" :name="icon" class="app-button__icon" />
    <span v-if="label" class="app-button__label">{{ label }}</span>
    <slot v-else />
  </button>
</template>

<script setup lang="ts">
defineOptions({ name: 'AppButton' });

withDefaults(
  defineProps<{
    label?: string;
    icon?: string;
    variant?: 'fill' | 'outline' | 'flat';
    size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
    rounded?: boolean;
    loading?: boolean;
    disabled?: boolean;
  }>(),
  {
    variant: 'fill',
    size: 'md',
    rounded: false,
    loading: false,
    disabled: false,
  },
);

defineEmits<{
  click: [event: Event];
}>();
</script>

<style scoped lang="scss">
.app-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: var(--btn-padding-y) var(--btn-padding-x);
  font-size: var(--btn-font-size);
  font-weight: 500;
  font-family: var(--font-family-primary);
  border: none;
  border-radius: var(--btn-radius);
  cursor: pointer;
  transition: background-color 0.2s, color 0.2s, border-color 0.2s;

  &--rounded {
    border-radius: var(--btn-radius-rounded);
  }

  &--fill {
    background: var(--btn-filled-bg);
    color: var(--btn-filled-color);

    &:hover:not(:disabled) {
      background: var(--btn-filled-hover-bg);
    }

    &:disabled {
      background: var(--btn-disabled-bg);
      color: var(--btn-disabled-color);
      cursor: not-allowed;
    }
  }

  &--outline {
    background: transparent;
    color: var(--btn-outline-color);
    border: 1px solid var(--btn-outline-border);

    &:hover:not(:disabled) {
      background: var(--btn-outline-hover-bg);
    }

    &:disabled {
      border-color: var(--btn-disabled-color);
      color: var(--btn-disabled-color);
      cursor: not-allowed;
    }
  }

  &--flat {
    background: transparent;
    color: var(--btn-flat-color);

    &:hover:not(:disabled) {
      background: var(--btn-flat-hover-bg);
    }

    &:disabled {
      color: var(--btn-disabled-color);
      cursor: not-allowed;
    }
  }

  &__icon,
  &__spinner {
    flex-shrink: 0;
  }
}
</style>
