<template>
  <div class="order-empty-state">
    <p class="order-empty-state__message">
      {{ message }}
    </p>
    <a
      v-if="actionLabel"
      href="#"
      class="order-empty-state__action"
      @click.prevent="$emit('action-click', $event)"
    >
      {{ actionLabel }}
    </a>
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'OrderEmptyState' });

withDefaults(
  defineProps<{
    message?: string;
    actionLabel?: string;
  }>(),
  {
    message: 'Заявок на подбор пока нет.',
    actionLabel: 'Создать заявку',
  },
);

defineEmits<{
  'action-click': [event: Event];
}>();
</script>

<style scoped lang="scss">
.order-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  flex: 1 1 0; /* заполняет всю высоту контейнера */
  min-height: 0;
  padding: 48px 24px;
  text-align: center;
  background: var(--color-bg-surface); /* Color/BG/color-bg-surface */
  border-radius: 8px; /* скругление для блока */
}

.order-empty-state__message {
  margin: 0 0 12px 0;
  font-family: var(--font-family-fa); /* Typography/FA — Montserrat */
  font-size: var(--order-empty-message-font-size);
  line-height: var(--order-empty-message-line-height);
  color: var(--order-empty-message-color);
  font-weight: 400; /* Regular */
}

.order-empty-state__action {
  font-family: var(--font-family-fa); /* Typography/FA — Montserrat */
  font-size: var(--order-empty-action-font-size);
  line-height: var(--order-empty-action-line-height);
  color: var(--order-empty-action-color);
  font-weight: 400; /* Regular */
  text-decoration: underline;
  cursor: pointer;
  transition: color 0.2s;

  &:hover {
    color: var(--order-empty-action-color-hover);
  }
}
</style>
