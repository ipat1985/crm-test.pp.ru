<template>
  <nav class="stepper-menu" aria-label="Шаги формы">
    <div v-for="(item, index) in items" :key="item.value" class="stepper-menu__entry">
      <button
        type="button"
        class="stepper-menu__item"
        :class="[`stepper-menu__item--${resolveState(item.value)}`, { 'stepper-menu__item--clickable': canNavigate(index) }]"
        :disabled="!canNavigate(index)"
        @click="onItemClick(item.value, index)"
      >
        <span class="stepper-menu__icon" :class="`stepper-menu__icon--${resolveState(item.value)}`">
          <q-icon
            v-if="resolveState(item.value) === 'done' || resolveState(item.value) === 'done-active'"
            name="o_check"
            class="stepper-menu__check"
          />
        </span>
        <span class="stepper-menu__label">{{ item.label }}</span>
      </button>

      <div v-if="index < items.length - 1 && index === currentIndex()" class="stepper-menu__line-wrap">
        <span class="stepper-menu__line" />
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
defineOptions({ name: 'StepperMenu' });

type FormSection = 'description' | 'requirements' | 'sources' | 'pipeline-template' | 'recruiters';
interface StepperMenuItemData {
  label: string;
  value: FormSection;
}

const props = withDefaults(
  defineProps<{
    modelValue?: FormSection;
    items?: StepperMenuItemData[];
    completedSections?: Partial<Record<FormSection, boolean>>;
    maxReachedIndex?: number;
  }>(),
  {
    modelValue: 'description',
    items: () => [
      { label: 'Описание заявки', value: 'description' },
      { label: 'Условия и требования', value: 'requirements' },
      { label: 'Источники', value: 'sources' },
      { label: 'Шаблон воронки', value: 'pipeline-template' },
      { label: 'Рекрутеры', value: 'recruiters' },
    ],
    completedSections: () => ({}),
    maxReachedIndex: 0,
  },
);

const emit = defineEmits<{
  'update:modelValue': [value: FormSection];
}>();

function canNavigate(index: number): boolean {
  return index <= props.maxReachedIndex;
}

function resolveState(value: FormSection): 'default' | 'active' | 'done' | 'done-active' {
  const isCompleted = Boolean(props.completedSections?.[value]);

  if (props.modelValue === value && isCompleted) return 'done-active';
  if (props.modelValue === value) return 'active';
  if (isCompleted) return 'done';
  return 'default';
}

function currentIndex(): number {
  return props.items.findIndex((item) => item.value === props.modelValue);
}

function onItemClick(value: FormSection, index: number): void {
  if (!canNavigate(index)) return;
  emit('update:modelValue', value);
}
</script>

<style scoped lang="scss">
.stepper-menu {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 8px;
  padding: 0 16px;
  box-sizing: border-box;
}

.stepper-menu__entry {
  width: 100%;
  display: flex;
  flex-direction: column;
}

.stepper-menu__item {
  width: 100%;
  border: 0;
  background: transparent;
  padding: 0;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: var(--color-secondary-light, #999ca6);
  text-align: left;
}

.stepper-menu__item--clickable {
  cursor: pointer;
}

.stepper-menu__icon {
  width: 24px;
  height: 24px;
  border-radius: 999px;
  border: 2px solid var(--color-secondary-light, #999ca6);
  box-sizing: border-box;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: 0 0 auto;
  background: transparent;
}

.stepper-menu__label {
  font-family: var(--font-family-fa);
  font-size: 16px;
  line-height: 20px;
  color: inherit;
}

.stepper-menu__item--active {
  color: var(--color-primary-main);
}

.stepper-menu__item--active .stepper-menu__icon {
  border-color: var(--color-primary-main);
}

.stepper-menu__item--done {
  color: var(--color-primary-main);
  opacity: 0.7;
}

.stepper-menu__item--done-active {
  color: var(--color-primary-main);
}

.stepper-menu__icon--done {
  border-color: var(--color-primary-main);
  background: var(--color-primary-main);
}

.stepper-menu__icon--done-active {
  border-color: var(--color-primary-main);
  background: var(--color-primary-main);
}

.stepper-menu__check {
  color: #fff;
  font-size: 16px;
}

.stepper-menu__line-wrap {
  margin: 8px 0 0 11px;
  height: 44px;
  display: flex;
  align-items: center;
}

.stepper-menu__line {
  width: 1px;
  height: 100%;
  background: var(--color-secondary-light, #999ca6);
}
</style>
