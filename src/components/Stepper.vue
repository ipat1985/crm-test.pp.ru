<template>
  <div class="stepper" :class="[`stepper--${orientation}`, { 'stepper--rtl': rtl }]">
    <div v-for="(step, index) in steps" :key="step.id ?? index" class="stepper__item">
      <template v-if="orientation === 'horizontal'">
        <div class="stepper__row" :class="{ 'stepper__row--rtl': rtl }">
          <StepperIcon :state="resolveState(step, index)" :icon-name="iconName" />
          <TextStepper
            :title="step.title"
            :subtitle="step.subtitle ?? 'Optional'"
            :state="resolveState(step, index)"
            :rtl="rtl"
          />
          <StepperLine
            v-if="showConnectors && index < steps.length - 1"
            orientation="horizontal"
            :length="lineLength"
          />
        </div>
      </template>

      <template v-else>
        <div class="stepper__row" :class="{ 'stepper__row--rtl': rtl }">
          <StepperIcon :state="resolveState(step, index)" :icon-name="iconName" />
          <TextStepper
            :title="step.title"
            :subtitle="step.subtitle ?? 'Optional'"
            :state="resolveState(step, index)"
            :rtl="rtl"
          />
        </div>
        <div v-if="showConnectors && index < steps.length - 1" class="stepper__vertical-line-wrap" :class="{ 'stepper__vertical-line-wrap--rtl': rtl }">
          <StepperLine orientation="vertical" :length="lineLength" />
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import StepperIcon from './StepperIcon.vue';
import StepperLine from './StepperLine.vue';
import TextStepper from './TextStepper.vue';

defineOptions({ name: 'StepperComponent' });

type StepState = 'default' | 'active' | 'error';
interface StepperItem {
  id?: string | number;
  title: string;
  subtitle?: string;
  state?: StepState;
}

const props = withDefaults(
  defineProps<{
    steps: StepperItem[];
    orientation?: 'horizontal' | 'vertical';
    rtl?: boolean;
    activeIndex?: number;
    completedIndices?: number[];
    errorIndices?: number[];
    iconName?: string;
    showConnectors?: boolean;
    lineLength?: number;
  }>(),
  {
    orientation: 'vertical',
    rtl: false,
    activeIndex: -1,
    completedIndices: () => [],
    errorIndices: () => [],
    iconName: 'o_info',
    showConnectors: true,
    lineLength: 44,
  },
);

function resolveState(step: StepperItem, index: number): StepState {
  if (step.state) return step.state;
  if (props.errorIndices.includes(index)) return 'error';
  if (index === props.activeIndex || props.completedIndices.includes(index)) return 'active';
  return 'default';
}
</script>

<style scoped lang="scss">
.stepper {
  display: flex;
}

.stepper--horizontal {
  flex-direction: row;
  align-items: center;
  gap: 16px;
}

.stepper--vertical {
  flex-direction: column;
  align-items: flex-start;
  gap: 0;
}

.stepper--rtl.stepper--vertical {
  align-items: flex-end;
}

.stepper__item {
  min-width: 0;
}

.stepper__row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.stepper__row--rtl {
  flex-direction: row-reverse;
}

.stepper__vertical-line-wrap {
  margin: 8px 0 8px 12px;
}

.stepper__vertical-line-wrap--rtl {
  margin: 8px 12px 8px 0;
  display: flex;
  justify-content: flex-end;
}
</style>
