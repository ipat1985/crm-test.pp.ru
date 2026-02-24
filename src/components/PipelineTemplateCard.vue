<template>
  <article
    class="pipeline-template-card"
    :class="{
      'pipeline-template-card--disabled': !enabled,
      'pipeline-template-card--editing': isEditing,
    }"
  >
    <header class="pipeline-template-card__header">
      <div class="pipeline-template-card__avatar">
        <q-icon name="o_filter_alt" />
      </div>
      <div class="pipeline-template-card__heading">
        <div class="pipeline-template-card__title">{{ title }}</div>
        <div class="pipeline-template-card__subtitle">{{ subtitle }}</div>
      </div>
    </header>

    <div class="pipeline-template-card__description">
      {{ description }}
    </div>

    <div v-if="enabled" class="pipeline-template-card__sources">
      <div
        v-for="source in sourceOptions"
        :key="source.value"
        class="pipeline-template-card__source-item"
      >
        <div class="pipeline-template-card__source-info">
          <img
            v-if="source.logo"
            :src="source.logo"
            :alt="source.label"
            class="pipeline-template-card__source-logo"
          />
          <div class="pipeline-template-card__source-text">
            <div class="pipeline-template-card__source-name">{{ source.label }}</div>
            <div v-if="source.status" class="pipeline-template-card__source-status">{{ source.status }}</div>
          </div>
        </div>
        <ToggleIndicator
          :checked="isSourceEnabled(source.value)"
          size="md"
          @click="toggleSource(source.value)"
        />
      </div>
    </div>

    <footer class="pipeline-template-card__footer">
      <button
        v-if="!isEditing"
        type="button"
        class="pipeline-template-card__edit-btn"
        @click="startEditing"
      >
        Настроить источники
      </button>
      <button
        v-else
        type="button"
        class="pipeline-template-card__save-btn"
        @click="saveChanges"
      >
        Сохранить
      </button>
      <button
        v-if="enabled"
        type="button"
        class="pipeline-template-card__toggle-btn"
        @click="$emit('update:enabled', false)"
      >
        <ToggleIndicator :checked="true" size="md" />
        <span class="pipeline-template-card__toggle-label">Вкл</span>
      </button>
      <button
        v-else
        type="button"
        class="pipeline-template-card__toggle-btn pipeline-template-card__toggle-btn--off"
        @click="$emit('update:enabled', true)"
      >
        <ToggleIndicator :checked="false" size="md" />
        <span class="pipeline-template-card__toggle-label">Выкл</span>
      </button>
    </footer>
  </article>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import ToggleIndicator from './ToggleIndicator.vue';

defineOptions({ name: 'PipelineTemplateCard' });

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  subtitle: {
    type: String,
    default: 'Администратор',
  },
  description: {
    type: String,
    default: 'Короткое описание или инструкция для чего используется эта воронка',
  },
  enabled: {
    type: Boolean,
    default: true,
  },
  sourceOptions: {
    type: Array as () => Array<{
      label: string;
      value: string;
      logo?: string;
      status?: string;
    }>,
    default: () => [],
  },
  modelValue: {
    type: Array as () => Array<string | number>,
    default: () => [],
  },
});

const emit = defineEmits<{
  'update:enabled': [value: boolean];
  'update:modelValue': [value: Array<string | number>];
}>();

const isEditing = ref(false);
const editingSources = ref<Array<string | number>>([]);

const selectedSources = computed(() => (isEditing.value ? editingSources.value : props.modelValue));

function isSourceEnabled(value: string | number): boolean {
  return selectedSources.value.includes(value);
}

function toggleSource(value: string | number): void {
  if (!isEditing.value) return;
  const index = editingSources.value.indexOf(value);
  if (index > -1) {
    editingSources.value.splice(index, 1);
  } else {
    editingSources.value.push(value);
  }
}

function startEditing(): void {
  editingSources.value = [...props.modelValue];
  isEditing.value = true;
}

function saveChanges(): void {
  emit('update:modelValue', [...editingSources.value]);
  isEditing.value = false;
}
</script>

<style scoped lang="scss">
.pipeline-template-card {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  background: var(--color-bg-white);
  overflow: visible;
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
}

.pipeline-template-card--disabled {
  opacity: 0.6;
}

.pipeline-template-card__header {
  min-height: 56px;
  padding: 8px 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  background: var(--color-primary-opacity-light);
  border-bottom: 1px solid #e0e0e0;
}

.pipeline-template-card--disabled .pipeline-template-card__header {
  background: transparent;
}

.pipeline-template-card__avatar {
  width: 32px;
  height: 32px;
  border-radius: 99px;
  background: var(--color-primary-main);
  color: var(--color-bg-white);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: 0 0 auto;
}

.pipeline-template-card--disabled .pipeline-template-card__avatar {
  background: #e0e0e0;
  color: #999;
}

.pipeline-template-card__avatar :deep(.q-icon) {
  font-size: 18px;
}

.pipeline-template-card__heading {
  min-width: 0;
}

.pipeline-template-card__title {
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
  font-weight: 700;
  color: #474747;
}

.pipeline-template-card__subtitle {
  font-family: var(--font-family-roboto);
  font-size: 12px;
  line-height: 16px;
  color: var(--color-primary-main);
}

.pipeline-template-card--disabled .pipeline-template-card__subtitle {
  color: #999;
}

.pipeline-template-card__description {
  padding: 12px 16px;
  min-height: 56px;
  font-family: var(--font-family-roboto);
  font-size: 16px;
  line-height: 24px;
  color: var(--color-text-secondary);
  border-bottom: 1px solid #e0e0e0;
}

.pipeline-template-card__sources {
  padding: 12px 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  border-bottom: 1px solid #e0e0e0;
  min-height: 60px;
}

.pipeline-template-card__sources:empty::before {
  content: 'Нет подключенных источников';
  color: var(--color-text-secondary);
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
}

.pipeline-template-card__source-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.pipeline-template-card--editing .pipeline-template-card__source-item {
  cursor: pointer;
}

.pipeline-template-card--editing .pipeline-template-card__source-item :deep(.toggle-indicator) {
  opacity: 1 !important;
  cursor: pointer;
  pointer-events: auto;
}

.pipeline-template-card__source-item :deep(.toggle-indicator) {
  cursor: not-allowed;
  pointer-events: none;
}

.pipeline-template-card--editing .pipeline-template-card__source-item :deep(.toggle-indicator) {
  cursor: pointer;
  pointer-events: auto;
}

.pipeline-template-card__source-info {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
  min-width: 0;
}

.pipeline-template-card__source-logo {
  width: 32px;
  height: 32px;
  border-radius: 4px;
  object-fit: contain;
  flex-shrink: 0;
}

.pipeline-template-card__source-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.pipeline-template-card__source-name {
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
  color: var(--color-text-primary);
}

.pipeline-template-card__source-status {
  font-family: var(--font-family-roboto);
  font-size: 12px;
  line-height: 16px;
  color: var(--color-text-secondary);
}

.pipeline-template-card__footer {
  min-height: 52px;
  padding: 8px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.pipeline-template-card__edit-btn {
  border: 1px solid var(--color-primary-main);
  border-radius: 8px;
  background: transparent;
  color: var(--color-primary-main);
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 22px;
  font-weight: 500;
  padding: 6px 16px;
  cursor: pointer;
  transition: all 0.2s;

  &:hover {
    background: var(--color-primary-opacity-lighter);
  }
}

.pipeline-template-card__save-btn {
  border: 0;
  border-radius: 8px;
  background: var(--color-primary-main);
  color: var(--color-bg-white);
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 22px;
  font-weight: 500;
  padding: 6px 16px;
  cursor: pointer;
  transition: all 0.2s;

  &:hover {
    opacity: 0.9;
  }
}

.pipeline-template-card__toggle-btn {
  border: 0;
  background: transparent;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  color: var(--color-primary-main);
}

.pipeline-template-card__toggle-btn--off {
  color: var(--color-text-secondary);
}

.pipeline-template-card__toggle-label {
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
}
</style>
