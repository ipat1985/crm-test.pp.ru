<template>
  <div class="stepper-icon" :class="[`stepper-icon--${state}`]">
    <q-icon :name="iconName" class="stepper-icon__glyph" />
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'StepperIcon' });

withDefaults(
  defineProps<{
    state?: 'default' | 'active' | 'error';
    iconName?: string;
  }>(),
  {
    state: 'default',
    iconName: 'o_info',
  },
);
</script>

<style scoped lang="scss">
.stepper-icon {
  width: 24px;
  height: 24px;
  border-radius: 999px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: 0 0 auto;
}

.stepper-icon__glyph {
  font-size: 14px;
  color: #fff;
}

.stepper-icon--default {
  background: var(--color-secondary-light, #999ca6);
}

.stepper-icon--active {
  background: var(--color-primary-main);
}

.stepper-icon--error {
  background: var(--color-error-main, #ff4c51);
}
</style>
