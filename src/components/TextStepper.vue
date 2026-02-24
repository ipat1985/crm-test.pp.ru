<template>
  <div class="text-stepper" :class="[`text-stepper--${state}`, { 'text-stepper--rtl': rtl }]">
    <div class="text-stepper__title">{{ title }}</div>
    <div v-if="subtitle" class="text-stepper__subtitle">{{ subtitle }}</div>
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'TextStepper' });

withDefaults(
  defineProps<{
    title: string;
    subtitle?: string;
    state?: 'default' | 'active' | 'error';
    rtl?: boolean;
  }>(),
  {
    subtitle: 'Optional',
    state: 'default',
    rtl: false,
  },
);
</script>

<style scoped lang="scss">
.text-stepper {
  min-width: 0;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  color: var(--color-secondary-light, #999ca6);
  font-family: var(--font-family-fa);
}

.text-stepper--rtl {
  align-items: flex-end;
  text-align: right;
}

.text-stepper__title {
  font-size: 16px;
  line-height: 24px;
}

.text-stepper__subtitle {
  font-size: 14px;
  line-height: 20px;
}

.text-stepper--active {
  color: var(--color-primary-main);
}

.text-stepper--error {
  color: var(--color-error-main, #ff4c51);
}
</style>
