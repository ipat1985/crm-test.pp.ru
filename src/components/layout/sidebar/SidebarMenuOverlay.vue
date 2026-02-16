<template>
  <div class="sidebar-menu-overlay">
    <div class="sidebar-menu-overlay__header">
      <span class="sidebar-menu-overlay__title">{{ title }}</span>
    </div>
    <div class="sidebar-menu-overlay__list">
      <router-link
        v-for="child in children"
        :key="child.title"
        :to="child.to"
        class="sidebar-menu-overlay__item"
        :class="{ 'sidebar-menu-overlay__item--active': activeRoute === child.to }"
        @click="$emit('select')"
      >
        <q-icon :name="child.icon" class="sidebar-menu-overlay__item-icon" size="12px" />
        <span class="sidebar-menu-overlay__item-label">{{ child.title }}</span>
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
export interface SidebarMenuOverlayItem {
  title: string;
  icon: string;
  to: string;
}

defineProps<{
  title: string;
  children: SidebarMenuOverlayItem[];
  activeRoute: string;
}>();

defineEmits<{
  select: [];
}>();
</script>

<style scoped lang="scss">
.sidebar-menu-overlay {
  border-radius: var(--sidebar-menu-overlay-radius);
  box-shadow: var(--sidebar-menu-overlay-shadow);
  overflow: hidden;
  min-width: var(--sidebar-menu-overlay-min-width);

  &__header {
    padding: var(--sidebar-menu-overlay-header-padding);
    background: var(--sidebar-menu-overlay-header-bg);
    color: var(--sidebar-menu-overlay-header-text);
  }

  &__title {
    font-size: 14px;
    font-weight: 600;
  }

  &__list {
    padding: var(--sidebar-menu-overlay-list-padding);
    background: var(--sidebar-menu-overlay-list-bg);
  }

  &__item {
    display: flex;
    align-items: center;
    gap: var(--sidebar-menu-icon-gap);
    padding: 10px 12px;
    border-radius: var(--sidebar-menu-item-radius);
    color: var(--sidebar-subitem-text);
    text-decoration: none;
    transition: background-color 0.2s;

    &:hover {
      background: var(--sidebar-menu-item-hover-bg);
    }

    &--active {
      color: var(--sidebar-subitem-active-text);
      font-weight: 500;

      .sidebar-menu-overlay__item-icon {
        color: var(--sidebar-subitem-active-icon);
      }
    }

    &-icon {
      flex-shrink: 0;
      color: var(--sidebar-subitem-icon);
    }

    &-label {
      font-size: 14px;
    }
  }
}
</style>
