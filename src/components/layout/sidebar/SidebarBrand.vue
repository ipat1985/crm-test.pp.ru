<template>
  <div class="sidebar-brand" :class="{ 'sidebar-brand--collapsed': collapsed }">
    <div class="sidebar-brand__logo">
      <span class="sidebar-brand__logo-text">PP</span>
    </div>
    <div v-show="!collapsed" class="sidebar-brand__content">
      <div class="sidebar-brand__title">РАБОЧИЕ РУКИ</div>
      <div class="sidebar-brand__slogan">B2B-платформа для найма самозанятых исполнителей</div>
    </div>
  </div>
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
  gap: 12px;
  padding: 16px;
  height: 72px;
  min-height: 72px;
  box-sizing: border-box;
  background: var(--sidebar-brand-bg);
  flex-shrink: 0;

  &--collapsed {
    justify-content: center;
  }

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

  &__content {
    min-width: 0;
  }

  &__title {
    font-weight: 700;
    font-size: 14px;
    color: var(--sidebar-brand-title);
    line-height: 1.2;
  }

  &__slogan {
    font-size: 12px;
    color: var(--sidebar-brand-slogan);
    margin-top: 2px;
    line-height: 1.3;
  }
}
</style>
