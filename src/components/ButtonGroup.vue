<template>
  <div
    class="button-group"
    :class="[
      `button-group--${variant}`,
      `button-group--${shape}`,
      { 'button-group--grouped': grouped },
      { 'button-group--separated': !grouped },
    ]"
  >
    <slot />
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'AppButtonGroup' });

withDefaults(
  defineProps<{
    variant?: 'fill' | 'outline' | 'flat';
    shape?: 'rectangular' | 'rounded';
    grouped?: boolean;
  }>(),
  {
    variant: 'flat',
    shape: 'rectangular',
    grouped: false,
  },
);
</script>

<style scoped lang="scss">
.button-group {
  display: inline-flex;
  align-items: center;

  &--grouped {
    gap: 0;

    :deep(.app-button) {
      border-radius: 0;

      &:first-child {
        border-top-left-radius: var(--btn-radius);
        border-bottom-left-radius: var(--btn-radius);
      }
      &:last-child {
        border-top-right-radius: var(--btn-radius);
        border-bottom-right-radius: var(--btn-radius);
      }
    }

    &.button-group--rounded :deep(.app-button) {
      &:first-child {
        border-radius: var(--btn-radius-rounded) 0 0 var(--btn-radius-rounded);
      }
      &:last-child {
        border-radius: 0 var(--btn-radius-rounded) var(--btn-radius-rounded) 0;
      }
    }
  }

  &--separated {
    gap: var(--btn-group-gap);
  }
}
</style>
