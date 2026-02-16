<template>
  <div class="task-empty-state">
    <p class="task-empty-state__message">
      {{ message }}
    </p>
    <a
      v-if="actionLabel"
      href="#"
      class="task-empty-state__action"
      @click.prevent="$emit('action-click', $event)"
    >
      {{ actionLabel }}
    </a>
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'TaskEmptyState' });

withDefaults(
  defineProps<{
    message?: string;
    actionLabel?: string;
  }>(),
  {
    message: 'Заданий пока нет.',
    actionLabel: 'Создать задание',
  },
);

defineEmits<{
  'action-click': [event: Event];
}>();
</script>

<style scoped lang="scss">
.task-empty-state {
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

.task-empty-state__message {
  margin: 0 0 12px 0;
  font-family: var(--font-family-fa); /* Typography/FA — Montserrat */
  font-size: var(--task-empty-message-font-size);
  line-height: var(--task-empty-message-line-height);
  color: var(--task-empty-message-color);
  font-weight: 400; /* Regular */
}

.task-empty-state__action {
  font-family: var(--font-family-fa); /* Typography/FA — Montserrat */
  font-size: var(--task-empty-action-font-size);
  line-height: var(--task-empty-action-line-height);
  color: var(--task-empty-action-color);
  font-weight: 400; /* Regular */
  text-decoration: underline;
  cursor: pointer;
  transition: color 0.2s;

  &:hover {
    color: var(--task-empty-action-color-hover);
  }
}
</style>
