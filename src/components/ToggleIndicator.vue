<template>
  <span
    class="toggle-indicator"
    :class="[
      `toggle-indicator--${size}`,
      { 'toggle-indicator--checked': checked },
      { 'toggle-indicator--hover': state === 'hover' },
      { 'toggle-indicator--disabled': state === 'disabled' },
    ]"
    aria-hidden="true"
  >
    <span class="toggle-indicator__track">
      <span v-if="state === 'hover'" class="toggle-indicator__hover-ring" />
      <span class="toggle-indicator__rail" />
      <span
        class="toggle-indicator__thumb"
        :class="{ 'toggle-indicator__thumb--right': isThumbRight }"
      />
    </span>
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue';

defineOptions({ name: 'ToggleIndicator' });

const props = withDefaults(
  defineProps<{
    checked?: boolean;
    flip?: boolean;
    size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
    state?: 'default' | 'hover' | 'disabled';
  }>(),
  {
    checked: false,
    flip: false,
    size: 'md',
    state: 'default',
  },
);

const isThumbRight = computed(() => props.checked !== props.flip);
</script>

<style scoped lang="scss">
.toggle-indicator {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: var(--toggle-hit-width);
  height: var(--toggle-hit-height);
  min-width: var(--toggle-hit-width);
  min-height: var(--toggle-hit-height);
  position: relative;
  box-sizing: border-box;

  &--xs {
    --toggle-track-width: var(--toggle-indicator-track-width-xs);
    --toggle-track-height: var(--toggle-indicator-track-height-xs);
    --toggle-rail-height: var(--toggle-indicator-rail-height-xs);
    --toggle-thumb-size: var(--toggle-indicator-thumb-size-xs);
    --toggle-hit-width: var(--toggle-indicator-hit-width-xs);
    --toggle-hit-height: var(--toggle-indicator-hit-height-xs);
  }

  &--sm {
    --toggle-track-width: var(--toggle-indicator-track-width-sm);
    --toggle-track-height: var(--toggle-indicator-track-height-sm);
    --toggle-rail-height: var(--toggle-indicator-rail-height-sm);
    --toggle-thumb-size: var(--toggle-indicator-thumb-size-sm);
    --toggle-hit-width: var(--toggle-indicator-hit-width-sm);
    --toggle-hit-height: var(--toggle-indicator-hit-height-sm);
  }

  &--md {
    --toggle-track-width: var(--toggle-indicator-track-width-md);
    --toggle-track-height: var(--toggle-indicator-track-height-md);
    --toggle-rail-height: var(--toggle-indicator-rail-height-md);
    --toggle-thumb-size: var(--toggle-indicator-thumb-size-md);
    --toggle-hit-width: var(--toggle-indicator-hit-width-md);
    --toggle-hit-height: var(--toggle-indicator-hit-height-md);
  }

  &--lg {
    --toggle-track-width: var(--toggle-indicator-track-width-lg);
    --toggle-track-height: var(--toggle-indicator-track-height-lg);
    --toggle-rail-height: var(--toggle-indicator-rail-height-lg);
    --toggle-thumb-size: var(--toggle-indicator-thumb-size-lg);
    --toggle-hit-width: var(--toggle-indicator-hit-width-lg);
    --toggle-hit-height: var(--toggle-indicator-hit-height-lg);
  }

  &--xl {
    --toggle-track-width: var(--toggle-indicator-track-width-xl);
    --toggle-track-height: var(--toggle-indicator-track-height-xl);
    --toggle-rail-height: var(--toggle-indicator-rail-height-xl);
    --toggle-thumb-size: var(--toggle-indicator-thumb-size-xl);
    --toggle-hit-width: var(--toggle-indicator-hit-width-xl);
    --toggle-hit-height: var(--toggle-indicator-hit-height-xl);
  }

  &--disabled {
    opacity: var(--toggle-indicator-disabled-opacity);
  }
}

.toggle-indicator__track {
  position: relative;
  width: var(--toggle-track-width);
  height: var(--toggle-track-height);
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.toggle-indicator__hover-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  width: var(--toggle-indicator-hover-ring-size);
  height: var(--toggle-indicator-hover-ring-size);
  transform: translate(-50%, -50%);
  border-radius: 999px;
  background: var(--toggle-indicator-hover-ring-bg);
}

.toggle-indicator__rail {
  position: absolute;
  top: 50%;
  left: 0;
  width: var(--toggle-track-width);
  height: var(--toggle-rail-height);
  transform: translateY(-50%);
  border-radius: 999px;
  background: var(--toggle-indicator-rail-bg-off);
}

.toggle-indicator--checked .toggle-indicator__rail {
  background: var(--toggle-indicator-rail-bg-on);
}

.toggle-indicator__thumb {
  position: absolute;
  top: 50%;
  left: 0;
  width: var(--toggle-thumb-size);
  height: var(--toggle-thumb-size);
  transform: translateY(-50%);
  border-radius: 999px;
  background: var(--toggle-indicator-thumb-bg-off);
  box-shadow: var(--toggle-indicator-thumb-shadow);
}

.toggle-indicator__thumb--right {
  transform: translate(
      calc(var(--toggle-track-width) - var(--toggle-thumb-size)),
      -50%
    );
}

.toggle-indicator--checked .toggle-indicator__thumb {
  background: var(--toggle-indicator-thumb-bg-on);
}
</style>
