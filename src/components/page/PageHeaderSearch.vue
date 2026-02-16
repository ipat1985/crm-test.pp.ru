<template>
  <q-input
    :model-value="modelValue"
    :placeholder="placeholder"
    :disabled="disabled"
    outlined
    dense
    class="page-header-search"
    hide-bottom-space
    v-bind="$attrs"
    @update:model-value="onInput($event)"
  >
    <template #prepend>
      <q-icon name="o_search" class="page-header-search__icon" size="20px" />
    </template>
  </q-input>
</template>

<script setup lang="ts">
defineOptions({ name: 'PageHeaderSearch' });

withDefaults(
  defineProps<{
    modelValue?: string;
    placeholder?: string;
    disabled?: boolean;
  }>(),
  { modelValue: '', disabled: false },
);

const emit = defineEmits<{
  'update:modelValue': [value: string];
}>();

function onInput(value: string | number | null): void {
  emit('update:modelValue', value != null ? String(value) : '');
}
</script>

<style scoped lang="scss">
.page-header-search {
  width: 100%;
}

.page-header-search :deep(.q-field__control) {
  height: var(--page-header-search-height);
  padding-left: 12px;
  padding-right: 12px;
  border-radius: var(--page-header-search-border-radius);
  background: var(--color-bg-white);
}

.page-header-search :deep(.q-field__control::before) {
  border-radius: var(--page-header-search-border-radius);
  border-color: var(--color-border-outline);
}

.page-header-search :deep(.q-field--focused .q-field__control::before) {
  border-color: var(--color-primary-main);
}

.page-header-search :deep(.q-field__native) {
  color: var(--color-text-primary);
  font-size: 14px;
}

.page-header-search :deep(.q-field__native::placeholder) {
  color: var(--page-header-search-placeholder-color);
}

.page-header-search__icon {
  color: var(--color-text-secondary);
}
</style>
