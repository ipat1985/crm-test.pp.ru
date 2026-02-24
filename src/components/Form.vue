<template>
  <section class="form">
    <aside class="form__menu-pane">
      <StepperMenu
        :model-value="activeSection"
        :items="items"
        :completed-sections="completedSections"
        :max-reached-index="maxReachedIndex"
        @update:model-value="onMenuSectionSelect"
      />
    </aside>

    <div class="form__content-pane">
      <FormOrderContent
        v-model:title="formTitle"
        :section="activeSection"
        @update:section-valid="onSectionValidUpdate"
        @prev="goPrevSection"
        @cancel="$emit('cancel')"
        @next="goNextSection"
      />
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import StepperMenu from './StepperMenu.vue';
import FormOrderContent from './FormOrderContent.vue';

defineOptions({ name: 'FormLayout' });

type FormSection = 'description' | 'requirements' | 'sources' | 'pipeline-template' | 'recruiters';

interface FormMenuItemData {
  label: string;
  value: FormSection;
}

const props = withDefaults(
  defineProps<{
    modelValue?: FormSection;
    title?: string;
    items?: FormMenuItemData[];
  }>(),
  {
    modelValue: 'description',
    title: '',
    items: () => [
      { label: 'Описание заявки', value: 'description' },
      { label: 'Условия и требования', value: 'requirements' },
      { label: 'Источники', value: 'sources' },
      { label: 'Шаблон воронки', value: 'pipeline-template' },
      { label: 'Рекрутеры', value: 'recruiters' },
    ],
  },
);

const emit = defineEmits<{
  'update:modelValue': [value: FormSection];
  'update:title': [value: string];
  cancel: [];
}>();

const localSection = ref<FormSection>(props.modelValue);
const maxReachedIndex = ref(0);

watch(
  () => props.modelValue,
  (value) => {
    localSection.value = value;
    const index = props.items.findIndex((item) => item.value === value);
    if (index > maxReachedIndex.value) maxReachedIndex.value = index;
  },
);

const activeSection = computed({
  get: () => localSection.value,
  set: (value: FormSection) => {
    localSection.value = value;
    emit('update:modelValue', value);
  },
});

const completedSections = ref<Record<FormSection, boolean>>({
  description: false,
  requirements: false,
  sources: false,
  'pipeline-template': false,
  recruiters: false,
});

const formTitle = computed({
  get: () => props.title,
  set: (value: string) => emit('update:title', value),
});

const currentIndex = computed(() => props.items.findIndex((item) => item.value === activeSection.value));

function goToIndex(index: number): void {
  if (index < 0 || index >= props.items.length || index > maxReachedIndex.value) return;
  const target = props.items[index];
  if (!target) return;
  activeSection.value = target.value;
}

function onMenuSectionSelect(value: FormSection): void {
  const index = props.items.findIndex((item) => item.value === value);
  if (index === -1) return;
  goToIndex(index);
}

function onSectionValidUpdate(payload: { section: FormSection; valid: boolean }): void {
  completedSections.value[payload.section] = payload.valid;
}

function goPrevSection(): void {
  goToIndex(currentIndex.value - 1);
}

function goNextSection(): void {
  const current = activeSection.value;
  completedSections.value[current] = true;

  const nextIndex = currentIndex.value + 1;
  if (nextIndex < 0 || nextIndex >= props.items.length) return;
  maxReachedIndex.value = Math.max(maxReachedIndex.value, nextIndex);
  goToIndex(nextIndex);
}
</script>

<style scoped lang="scss">
.form {
  width: 100%;
  height: 100%;
  min-height: 0;
  display: grid;
  grid-template-columns: 270px minmax(0, 1fr);
  gap: 32px;
  align-items: stretch;
}

.form__menu-pane {
  background: var(--color-body-bg);
  min-height: 0;
  overflow: auto;
}

.form__content-pane {
  min-width: 0;
  background: var(--color-bg-white);
  min-height: 0;
  height: 100%;
  overflow: hidden;
}

@media (max-width: 1100px) {
  .form {
    grid-template-columns: 1fr;
    gap: 16px;
  }
}
</style>
