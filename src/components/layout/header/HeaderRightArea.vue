<template>
  <div class="header-right-area">
    <div class="header-right-area__user">
      <div class="header-right-area__text">
        <span class="header-right-area__title">{{ title }}</span>
        <span v-if="subtitle" class="header-right-area__subtitle">{{ subtitle }}</span>
      </div>
      <Avatar
        v-bind="avatar ? { src: avatar } : { text: initials }"
        size="sm"
        shape="full"
        class="header-right-area__avatar"
      />
    </div>
    <IconButton
      icon="o_notifications_none"
      variant="icon"
      :aria-label="notificationLabel"
      @click="$emit('notifications-click', $event)"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import Avatar from 'components/Avatar.vue';
import IconButton from 'components/IconButton.vue';

const props = withDefaults(
  defineProps<{
    title: string;
    subtitle?: string;
    avatar?: string;
    notificationLabel?: string;
  }>(),
  {
    subtitle: '',
    notificationLabel: 'Уведомления',
  },
);

defineEmits<{
  'notifications-click': [event: Event];
}>();

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
.header-right-area {
  display: flex;
  align-items: center;
  gap: var(--header-right-gap);
}

.header-right-area__user {
  display: flex;
  align-items: center;
  gap: var(--header-right-gap);
}

.header-right-area__text {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  text-align: right;
}

.header-right-area__title {
  font-size: var(--header-right-title-font-size);
  font-weight: 500;
  color: var(--header-right-title-color);
  line-height: 1.3;
}

.header-right-area__subtitle {
  font-size: var(--header-right-subtitle-font-size);
  color: var(--header-right-subtitle-color);
  line-height: 1.3;
}

.header-right-area__avatar {
  flex-shrink: 0;
}
</style>
