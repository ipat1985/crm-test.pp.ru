<template>
  <nav class="form-menu" aria-label="Разделы формы">
    <FormMenuItem
      v-for="(item, index) in items"
      :key="item.value"
      :label="item.label"
      :state="resolveItemState(item.value)"
      :left-icon="isDoneState(item.value)"
      left-icon-name="o_check_circle_outline"
      :right-icon="false"
      :clickable="canNavigate(index)"
      @click="onItemClick(item.value, index)"
    />
  </nav>
</template>

<script setup lang="ts">
import FormMenuItem from './FormMenuItem.vue';

defineOptions({ name: 'FormMenu' });

interface FormMenuItemData {
  label: string;
  value: 'description' | 'requirements' | 'sources' | 'pipeline-template' | 'recruiters';
}

const props = withDefaults(
  defineProps<{
    modelValue?: FormMenuItemData['value'];
    items?: FormMenuItemData[];
    completedSections?: Partial<Record<FormMenuItemData['value'], boolean>>;
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
  'update:modelValue': [value: FormMenuItemData['value']];
}>();

function resolveItemState(value: FormMenuItemData['value']): 'focused' | 'disable' | 'active-done' | 'unactive-done' {
  const isActive = props.modelValue === value;
  const isDone = Boolean(props.completedSections?.[value]);

  if (isActive && isDone) return 'active-done';
  if (isActive) return 'focused';
  if (isDone) return 'unactive-done';
  return 'disable';
}

function isDoneState(value: FormMenuItemData['value']): boolean {
  return Boolean(props.completedSections?.[value]);
}

function canNavigate(index: number): boolean {
  return index <= props.maxReachedIndex;
}

function onItemClick(value: FormMenuItemData['value'], index: number): void {
  if (!canNavigate(index)) return;
  emit('update:modelValue', value);
}
</script>

<style scoped lang="scss">
.form-menu {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 9px;
}
</style>
