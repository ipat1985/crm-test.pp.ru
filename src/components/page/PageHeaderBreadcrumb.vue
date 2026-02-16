<template>
  <nav class="page-header-breadcrumb" aria-label="Хлебные крошки">
    <template v-for="(item, index) in items" :key="index">
      <template v-if="index > 0">
        <span class="page-header-breadcrumb__separator" aria-hidden="true">
          {{ separator }}
        </span>
      </template>
      <component
        :is="item.to ? 'router-link' : 'span'"
        :to="item.to"
        class="page-header-breadcrumb__item"
        :class="{ 'page-header-breadcrumb__item--current': index === items.length - 1 }"
      >
        {{ item.label }}
      </component>
    </template>
  </nav>
</template>

<script setup lang="ts">
defineOptions({ name: 'PageHeaderBreadcrumb' });

withDefaults(
  defineProps<{
    /** Элементы цепочки: последний — текущая страница (без to) */
    items: Array<{ label: string; to?: string }>;
    /** Разделитель между элементами */
    separator?: string;
  }>(),
  { separator: ' / ' },
);
</script>

<style scoped lang="scss">
.page-header-breadcrumb {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0;
  font-family: var(--font-family-fa); /* Typography/FA стиль — Montserrat */
  font-size: var(--page-header-breadcrumb-font-size);
  line-height: var(--page-header-breadcrumb-line-height);
  color: var(--page-header-breadcrumb-color);
}

.page-header-breadcrumb__separator {
  margin: 0 6px;
  color: var(--page-header-breadcrumb-separator);
  user-select: none;
}

.page-header-breadcrumb__item {
  color: inherit;
  text-decoration: none;

  &:hover {
    color: var(--color-primary-main);
  }

  &--current {
    color: var(--color-text-primary);
    font-weight: 500;
    pointer-events: none;
  }
}
</style>
