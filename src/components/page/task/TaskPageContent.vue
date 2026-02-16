<template>
  <div class="task-page-content">
    <slot />
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'TaskPageContent' });
</script>

<style scoped lang="scss">
.task-page-content {
  /* Контент страницы «Задания» — макет Figma 222-8438 */
  display: flex;
  flex-direction: column;
  flex: 1 1 0;
  min-height: 0;
  width: 100%;
  overflow-y: auto;
}
</style>
