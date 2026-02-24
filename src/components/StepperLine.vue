<template>
  <span class="stepper-line" :class="[`stepper-line--${orientation}`]" :style="lineStyle" />
</template>

<script setup lang="ts">
import { computed } from 'vue';

defineOptions({ name: 'StepperLine' });

const props = withDefaults(
  defineProps<{
    orientation?: 'horizontal' | 'vertical';
    length?: number;
  }>(),
  {
    orientation: 'horizontal',
    length: 100,
  },
);

const lineStyle = computed<Record<string, string>>(() =>
  props.orientation === 'horizontal'
    ? { width: `${props.length}px` }
    : { height: `${props.length}px` },
);
</script>

<style scoped lang="scss">
.stepper-line {
  display: inline-block;
  background: var(--color-secondary-light, #999ca6);
  flex: 0 0 auto;
}

.stepper-line--horizontal {
  height: 1px;
}

.stepper-line--vertical {
  width: 1px;
}
</style>
