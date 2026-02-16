<template>
  <div class="card">
    <!-- Header: avatar + title + subtitle -->
    <CardHeader
      v-if="headerTitle"
      :title="headerTitle"
      :subtitle="headerSubtitle"
      v-bind="headerAvatar ? { avatar: headerAvatar } : {}"
    />
    <slot v-else name="header" />

    <!-- Media: image or slot -->
    <div v-if="$slots.media" class="card__media">
      <slot name="media" />
    </div>

    <!-- Content: default slot -->
    <div v-if="$slots.default" class="card__content">
      <slot />
    </div>

    <!-- Actions: buttons -->
    <div v-if="$slots.actions" class="card__actions">
      <slot name="actions" />
    </div>
  </div>
</template>

<script setup lang="ts">
import CardHeader from './CardHeader.vue';

defineOptions({ name: 'AppCard' });

withDefaults(
  defineProps<{
    headerTitle?: string;
    headerSubtitle?: string;
    headerAvatar?: string;
  }>(),
  {
    headerTitle: '',
    headerSubtitle: '',
  },
);
</script>

<style scoped lang="scss">
.card {
  background: var(--color-bg-white);
  border-radius: var(--card-radius);
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);

  &__media {
    :deep(img) {
      display: block;
      width: 100%;
      height: auto;
      vertical-align: middle;
    }
  }

  &__content {
    padding: var(--card-padding);
  }

  &__actions {
    display: flex;
    gap: var(--card-actions-gap);
    padding: 0 var(--card-padding) var(--card-padding);
  }
}
</style>
