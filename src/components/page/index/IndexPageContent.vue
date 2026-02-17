<template>
  <div class="index-page-content">
    <slot />
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'IndexPageContent' });
</script>

<style scoped lang="scss">
.index-page-content {
  /* Контент стартовой страницы — макет Figma 246-2205 */
  display: flex;
  flex-direction: column;
  flex: 1 1 0;
  min-height: 0;
  width: 100%;
  overflow-y: auto;
}
</style>
