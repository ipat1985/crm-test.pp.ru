<template>
  <span
    class="checkbox-indicator"
    :class="[
      `checkbox-indicator--${size}`,
      { 'checkbox-indicator--dense': dense },
      { 'checkbox-indicator--checked': checked || indeterminate },
      { 'checkbox-indicator--hover': state === 'hover' },
      { 'checkbox-indicator--disabled': state === 'disabled' },
    ]"
    aria-hidden="true"
  >
    <span class="checkbox-indicator__box">
      <q-icon
        v-if="checked || indeterminate"
        :name="indeterminate ? 'o_remove' : 'o_check'"
        class="checkbox-indicator__icon"
      />
    </span>
  </span>
</template>

<script setup lang="ts">
defineOptions({ name: 'CheckboxIndicator' });

withDefaults(
  defineProps<{
    checked?: boolean;
    indeterminate?: boolean;
    dense?: boolean;
    size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
    state?: 'default' | 'hover' | 'disabled';
  }>(),
  {
    checked: false,
    indeterminate: false,
    dense: false,
    size: 'md',
    state: 'default',
  },
);
</script>

<style scoped lang="scss">
.checkbox-indicator {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: var(--indicator-hit);
  height: var(--indicator-hit);
  min-width: var(--indicator-hit);
  min-height: var(--indicator-hit);
  border-radius: var(--checkbox-indicator-ring-radius);

  &--xs {
    --indicator-size: var(--checkbox-indicator-size-xs);
    --indicator-hit: var(--checkbox-indicator-hit-xs);
  }

  &--sm {
    --indicator-size: var(--checkbox-indicator-size-sm);
    --indicator-hit: var(--checkbox-indicator-hit-sm);
  }

  &--md {
    --indicator-size: var(--checkbox-indicator-size-md);
    --indicator-hit: var(--checkbox-indicator-hit-md);
  }

  &--lg {
    --indicator-size: var(--checkbox-indicator-size-lg);
    --indicator-hit: var(--checkbox-indicator-hit-lg);
  }

  &--xl {
    --indicator-size: var(--checkbox-indicator-size-xl);
    --indicator-hit: var(--checkbox-indicator-hit-xl);
  }

  &--dense {
    width: calc(var(--indicator-size) + 13px);
    height: calc(var(--indicator-size) + 13px);
    min-width: calc(var(--indicator-size) + 13px);
    min-height: calc(var(--indicator-size) + 13px);
  }

  &--hover {
    background: var(--checkbox-indicator-hover-ring);
  }

  &--disabled {
    opacity: var(--checkbox-disabled-opacity);
  }
}

.checkbox-indicator__box {
  width: var(--indicator-size);
  height: var(--indicator-size);
  border-radius: var(--checkbox-indicator-radius);
  border: var(--checkbox-indicator-border-width) solid var(--checkbox-indicator-border-color);
  background: transparent;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.checkbox-indicator--checked .checkbox-indicator__box {
  background: var(--checkbox-indicator-fill);
  border-color: var(--checkbox-indicator-fill);
}

.checkbox-indicator__icon {
  color: var(--checkbox-indicator-icon-color);
  font-size: calc(var(--indicator-size) * 0.85);
}
</style>
