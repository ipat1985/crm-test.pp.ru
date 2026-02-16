<template>
  <h1 class="page-header-title">
    <slot>{{ title }}</slot>
  </h1>
</template>

<script setup lang="ts">
defineOptions({ name: 'PageHeaderTitle' });

defineProps<{
  /** Заголовок страницы (если не задан слот) */
  title?: string;
}>();
</script>

<style scoped lang="scss">
.page-header-title {
  margin: 0;
  font-family: var(--typography-text-h5-font-family);
  font-size: var(--page-header-title-font-size);
  font-weight: var(--page-header-title-font-weight);
  line-height: var(--page-header-title-line-height);
  color: var(--page-header-title-color);
}
</style>
