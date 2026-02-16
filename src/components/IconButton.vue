<template>
  <q-btn
    :icon="icon"
    :round="shape === 'circle'"
    :flat="variant === 'icon' || variant === 'outlined'"
    :outline="variant === 'outlined'"
    :size="btnSize"
    :disable="disabled"
    :aria-label="ariaLabel"
    class="icon-button"
    :class="[
      `icon-button--${variant}`,
      `icon-button--${shape}`,
      { 'icon-button--active': active },
      { 'icon-button--badge': badge },
    ]"
    unelevated
    no-caps
    @click="$emit('click', $event)"
  >
    <q-badge
      v-if="badge"
      floating
      :color="badgeColor"
      :label="typeof badge === 'number' ? (badge > 99 ? '99+' : badge) : ''"
    />
  </q-btn>
</template>

<script setup lang="ts">
import { computed } from 'vue';

const props = withDefaults(
  defineProps<{
    icon: string;
    variant?: 'icon' | 'outlined' | 'filled';
    shape?: 'square' | 'circle';
    size?: 'sm' | 'md' | 'lg';
    active?: boolean;
    disabled?: boolean;
    badge?: boolean | number;
    badgeColor?: string;
    ariaLabel?: string;
  }>(),
  {
    variant: 'icon',
    shape: 'square',
    size: 'md',
    active: false,
    disabled: false,
    badge: false,
    badgeColor: 'primary',
  },
);

defineEmits<{
  click: [event: Event];
}>();

const btnSize = computed(() => {
  const map = { sm: 'sm', md: 'md', lg: 'lg' } as const;
  return map[props.size];
});
</script>

<style scoped lang="scss">
.icon-button {
  min-width: var(--icon-btn-size) !important;
  min-height: var(--icon-btn-size) !important;
  width: var(--icon-btn-size);
  height: var(--icon-btn-size);
  padding: 0 !important;
  border-radius: var(--icon-btn-radius);
  transition: background-color 0.2s, color 0.2s, border-color 0.2s;

  :deep(.q-icon) {
    font-size: var(--icon-btn-icon-size) !important;
  }

  /* Icon only */
  &--icon {
    background: var(--icon-btn-default-bg) !important;
    color: var(--icon-btn-default-color) !important;
    border: none;

    &:hover:not(.q-btn--disabled):not(.icon-button--active) {
      background: var(--icon-btn-default-filled-bg) !important;
      color: var(--icon-btn-default-color) !important;
    }

    &.icon-button--active {
      background: var(--icon-btn-active-filled-bg) !important;
      color: var(--icon-btn-active-filled-color) !important;
    }

    &.q-btn--disabled {
      color: var(--icon-btn-disabled-color) !important;
      opacity: var(--icon-btn-disabled-opacity);
    }
  }

  /* Outlined */
  &--outlined {
    background: var(--icon-btn-default-filled-bg) !important; /* светлый фиолетовый фон по макету */
    color: var(--icon-btn-default-outlined-color) !important;
    border: 1px solid var(--icon-btn-default-outlined-border) !important;

    &:hover:not(.q-btn--disabled):not(.icon-button--active) {
      background: var(--icon-btn-hover-filled-bg) !important;
      color: var(--icon-btn-default-color) !important;
      border-color: var(--icon-btn-default-outlined-border) !important;
    }

    &.icon-button--active {
      background: var(--icon-btn-active-filled-bg) !important;
      color: var(--icon-btn-active-filled-color) !important;
      border-color: transparent !important;
    }

    &.q-btn--disabled {
      background: var(--icon-btn-default-filled-bg) !important;
      color: var(--icon-btn-disabled-color) !important;
      border-color: var(--icon-btn-disabled-color) !important;
      opacity: var(--icon-btn-disabled-opacity);
    }
  }

  /* Filled */
  &--filled {
    background: var(--icon-btn-default-filled-bg) !important;
    color: var(--icon-btn-default-filled-color) !important;
    border: none;

    &:hover:not(.q-btn--disabled):not(.icon-button--active) {
      background: var(--icon-btn-hover-filled-bg) !important;
      color: var(--icon-btn-hover-filled-color) !important;
    }

    &.icon-button--active {
      background: var(--icon-btn-active-filled-bg) !important;
      color: var(--icon-btn-active-filled-color) !important;
    }

    &.q-btn--disabled {
      background: var(--icon-btn-default-filled-bg) !important;
      color: var(--icon-btn-disabled-color) !important;
      opacity: var(--icon-btn-disabled-opacity);
    }
  }

  /* Circle shape */
  &--circle {
    border-radius: 50%;
  }
}
</style>
