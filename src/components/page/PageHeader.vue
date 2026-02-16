<template>
  <header class="page-header">
    <div v-if="$slots.breadcrumb" class="page-header__breadcrumb">
      <slot name="breadcrumb" />
    </div>
    <div class="page-header__row">
      <div v-if="$slots.title" class="page-header__title-wrap">
        <slot name="title" />
      </div>
      <div v-if="$slots.actions" class="page-header__actions">
        <slot name="actions" />
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
defineOptions({ name: 'PageHeader' });
</script>

<style scoped lang="scss">
.page-header {
  display: flex;
  flex-direction: column;
  gap: var(--page-header-gap);
  margin-bottom: var(--page-header-margin-bottom);
  flex-shrink: 0;
}

.page-header__breadcrumb {
  display: block; /* убеждаемся, что элемент виден */
  font-size: var(--page-header-breadcrumb-font-size);
  line-height: var(--page-header-breadcrumb-line-height);
  color: var(--page-header-breadcrumb-color);
  opacity: 1; /* убеждаемся, что не прозрачный */
}

.page-header__row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: var(--page-header-actions-gap);
  min-width: 0;
}

.page-header__title-wrap {
  flex: 0 0 auto; /* размер по содержимому, не растягивается и не сжимается */
  width: fit-content; /* ширина по содержимому */
  margin-right: auto; /* отталкивает actions вправо */
}

.page-header__actions {
  flex: 0 0 auto; /* не растягивается, ширина по контенту */
  min-width: 0;
  display: flex;
  align-items: center;
  gap: var(--page-header-actions-gap);
}
</style>
