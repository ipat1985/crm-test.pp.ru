<template>
  <div class="layout-page-container">
    <slot />
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'LayoutPageContainer' });
</script>

<style scoped lang="scss">
.layout-page-container {
  display: flex;
  flex-direction: column;
  width: 100%;
  flex: 1 1 0;
  min-height: 0;
  padding: 32px var(--layout-page-container-padding) var(--layout-page-container-padding);
  background: var(--layout-page-container-bg);
  box-sizing: border-box;
}
</style>
