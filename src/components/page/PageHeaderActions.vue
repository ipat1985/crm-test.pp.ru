<template>
  <div class="page-header-actions">
    <div v-if="$slots.search" class="page-header-actions__search">
      <slot name="search" />
    </div>
    <div v-if="$slots.leading" class="page-header-actions__leading">
      <slot name="leading" />
    </div>
    <div v-if="$slots.default || primaryLabel" class="page-header-actions__main">
      <Button
        v-if="primaryLabel"
        :label="primaryLabel"
        v-bind="primaryIcon ? { icon: primaryIcon } : {}"
        :loading="primaryLoading"
        :disabled="primaryDisabled"
        variant="fill"
        size="md"
        @click="$emit('primary-click', $event)"
      />
      <slot v-else />
    </div>
  </div>
</template>

<script setup lang="ts">
import Button from 'components/Button.vue';

defineOptions({ name: 'PageHeaderActions' });

withDefaults(
  defineProps<{
    /** Текст основной кнопки (если задан — рендерится Button) */
    primaryLabel?: string;
    /** Иконка основной кнопки (например o_add) */
    primaryIcon?: string;
    primaryLoading?: boolean;
    primaryDisabled?: boolean;
  }>(),
  {
    primaryLoading: false,
    primaryDisabled: false,
  },
);

defineEmits<{
  'primary-click': [event: Event];
}>();
</script>

<style scoped lang="scss">
.page-header-actions {
  display: flex;
  align-items: center;
  gap: var(--page-header-actions-gap);
  width: 100%;
  min-width: 0;
}

.page-header-actions__search {
  flex: 0 0 auto; /* не растягивается, ширина по контенту */
  width: auto;
  min-width: 440px; /* минимальная ширина для плейсхолдера "Введите адрес, название или ИНН клиента" */
  max-width: 100%; /* не выходит за границы контейнера */
}

.page-header-actions__leading {
  display: flex;
  align-items: center;
  gap: var(--page-header-actions-gap);
  flex-shrink: 0;
}

.page-header-actions__main {
  display: flex;
  align-items: center;
  gap: var(--page-header-actions-gap);
  flex-shrink: 0;
}
</style>
