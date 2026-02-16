<template>
  <div class="sidebar" :class="{ 'sidebar--collapsed': collapsed }">
    <SidebarBrand :collapsed="collapsed" />
    <SidebarScrollArea :collapsed="collapsed" />
    <SidebarFooter :collapsed="collapsed" />
  </div>
</template>

<script setup lang="ts">
import SidebarBrand from './SidebarBrand.vue';
import SidebarScrollArea from './SidebarScrollArea.vue';
import SidebarFooter from './SidebarFooter.vue';

defineOptions({ name: 'LayoutSidebar' });

defineProps<{
  collapsed: boolean;
}>();
</script>

<style scoped lang="scss">
.sidebar {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-width: 280px;
  background: var(--sidebar-bg);

  &--collapsed {
    min-width: 72px;
  }
}
</style>
