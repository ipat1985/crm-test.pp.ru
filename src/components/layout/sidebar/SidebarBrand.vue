<template>
  <router-link
    to="/"
    class="sidebar-brand"
    :class="{ 'sidebar-brand--collapsed': collapsed }"
    aria-label="На главную"
  >
    <div class="sidebar-brand__logo">
      <span class="sidebar-brand__logo-text">PP</span>
    </div>
  </router-link>
</template>

<script setup lang="ts">
defineProps<{
  collapsed: boolean;
}>();
</script>

<style scoped lang="scss">
.sidebar-brand {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
  height: 72px;
  min-height: 72px;
  box-sizing: border-box;
  background: var(--sidebar-bg);
  flex-shrink: 0;
  text-decoration: none;
  color: inherit;

  &__logo {
    width: 40px;
    height: 40px;
    min-width: 40px;
    background: var(--sidebar-brand-logo-bg);
    border-radius: 8px;
    transform: rotate(45deg);
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__logo-text {
    transform: rotate(-45deg);
    color: var(--sidebar-brand-logo-text);
    font-weight: 700;
    font-size: 14px;
  }
}
</style>
