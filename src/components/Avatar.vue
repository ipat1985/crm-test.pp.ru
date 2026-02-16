<template>
  <div
    class="avatar"
    :class="[
      `avatar--${size}`,
      `avatar--${shape}`,
      { 'avatar--img': !!src },
    ]"
    :style="sizeStyle"
  >
    <img v-if="src" :src="src" :alt="alt" class="avatar__img" />
    <q-icon v-else-if="icon" :name="icon" class="avatar__icon" />
    <span v-else class="avatar__text">{{ text }}</span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';

defineOptions({ name: 'AppAvatar' });

const props = withDefaults(
  defineProps<{
    src?: string;
    icon?: string;
    text?: string;
    size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
    shape?: 'full' | 'default' | 'none';
  }>(),
  {
    size: 'md',
    shape: 'full',
  },
);

const alt = computed(() => props.text ?? 'Avatar');

const sizeStyle = computed(() => {
  const sizes: Record<string, string> = {
    xs: 'var(--avatar-size-xs)',
    sm: 'var(--avatar-size-sm)',
    md: 'var(--avatar-size-md)',
    lg: 'var(--avatar-size-lg)',
    xl: 'var(--avatar-size-xl)',
  };
  const dim = sizes[props.size] ?? '40px';
  return { width: dim, height: dim, minWidth: dim, minHeight: dim };
});
</script>

<style scoped lang="scss">
.avatar {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  background: var(--avatar-bg);
  color: var(--avatar-text-color);
  font-weight: 500;
  font-size: 0.5em;

  &--full {
    border-radius: var(--avatar-radius-full);
  }

  &--default {
    border-radius: var(--avatar-radius-default);
  }

  &--none {
    border-radius: var(--avatar-radius-none);
  }

  &--img {
    background: transparent;
  }

  &__img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  &__icon {
    font-size: 1.4em;
  }

  &__text {
    text-transform: uppercase;
  }
}
</style>
