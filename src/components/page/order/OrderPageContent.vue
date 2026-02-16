<template>
  <div class="order-page-content">
    <slot />
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'OrderPageContent' });
</script>

<style scoped lang="scss">
.order-page-content {
  /* Контент страницы «Заявки» — макет Figma 41-9114 */
  display: flex;
  flex-direction: column;
  flex: 1 1 0;
  min-height: 0;
  width: 100%;
  overflow-y: auto;
}
</style>
