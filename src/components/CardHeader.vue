<template>
  <div class="card-header">
    <div class="card-header__avatar">
      <Avatar
        v-if="props.avatar"
        :src="props.avatar"
        :size="avatarSizeName"
        shape="full"
      />
      <Avatar
        v-else
        :text="initials"
        :size="avatarSizeName"
        shape="full"
      />
    </div>
    <div class="card-header__content">
      <div class="card-header__title">{{ title }}</div>
      <div v-if="subtitle" class="card-header__subtitle">{{ subtitle }}</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import Avatar from './Avatar.vue';

const props = withDefaults(
  defineProps<{
    title: string;
    subtitle?: string;
    avatar?: string;
    avatarSize?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  }>(),
  {
    subtitle: '',
    avatarSize: 'md',
  },
);

const avatarSizeName = computed(() => props.avatarSize);

const initials = computed(() => {
  const t = props.title?.trim() ?? '';
  const words = t.split(/\s+/).filter(Boolean);
  if (words.length >= 2) {
    const w0 = words[0];
    const w1 = words[1];
    return ((w0?.[0] ?? '') + (w1?.[0] ?? '')).toUpperCase();
  }
  return t.slice(0, 2).toUpperCase() || '?';
});
</script>

<style scoped lang="scss">
.card-header {
  display: flex;
  align-items: center;
  gap: var(--card-header-gap);
  padding: var(--card-header-padding);

  &__avatar {
    flex-shrink: 0;
  }

  &__content {
    min-width: 0;
    flex: 1;
  }

  &__title {
    font-size: var(--card-header-title-font-size);
    font-weight: 500;
    color: var(--card-header-title-color);
    line-height: 1.3;
  }

  &__subtitle {
    margin-top: 2px;
    font-size: var(--card-header-subtitle-font-size);
    color: var(--card-header-subtitle-color);
    line-height: 1.3;
  }
}
</style>
