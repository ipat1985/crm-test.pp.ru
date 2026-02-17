<template>
  <div class="index-start-content">
    <p class="index-start-content__message">
      {{ message }}
    </p>
    <a
      v-if="actionLabel"
      href="#"
      class="index-start-content__action"
      @click.prevent="$emit('action-click', $event)"
    >
      {{ actionLabel }}
    </a>
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'IndexStartContent' });

withDefaults(
  defineProps<{
    message?: string;
    actionLabel?: string;
  }>(),
  {
    message: 'Это контент стартовой страницы',
    actionLabel: 'Добавить элемент',
  },
);

defineEmits<{
  'action-click': [event: Event];
}>();
</script>

<style scoped lang="scss">
.index-start-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  flex: 1 1 0;
  min-height: 0;
  padding: 48px 24px;
  text-align: center;
  background: var(--color-bg-surface);
  border-radius: 8px;
}

.index-start-content__message {
  margin: 0 0 12px 0;
  font-family: var(--font-family-fa);
  font-size: var(--index-start-message-font-size);
  line-height: var(--index-start-message-line-height);
  color: var(--index-start-message-color);
  font-weight: 400;
}

.index-start-content__action {
  font-family: var(--font-family-fa);
  font-size: var(--index-start-action-font-size);
  line-height: var(--index-start-action-line-height);
  color: var(--index-start-action-color);
  font-weight: 400;
  text-decoration: underline;
  cursor: pointer;
  transition: color 0.2s;

  &:hover {
    color: var(--index-start-action-color-hover);
  }
}
</style>
