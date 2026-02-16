<template>
  <div class="sidebar-footer" :class="{ 'sidebar-footer--collapsed': collapsed }">
    <q-btn
      flat
      no-caps
      :padding="collapsed ? '8px' : '12px 16px'"
      class="sidebar-footer__link"
      href="mailto:support@example.com"
      target="_blank"
    >
      <q-icon v-if="collapsed" name="o_support_agent" class="sidebar-footer__icon" size="24px" />
      <span v-else>Техническая поддержка</span>
    </q-btn>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  collapsed: boolean;
}>();
</script>

<style scoped lang="scss">
.sidebar-footer {
  flex-shrink: 0;
  padding: 8px 0;
  border-top: 1px solid var(--sidebar-footer-border);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;

  &--collapsed {
    flex-direction: column;
    gap: 4px;
  }

  &__link {
    color: var(--sidebar-footer-link);
    font-size: 14px;

    :deep(.q-icon) {
      color: var(--sidebar-footer-link);
      font-size: var(--sidebar-icon-size) !important;
    }
  }
}
</style>
