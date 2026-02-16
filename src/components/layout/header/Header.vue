<template>
  <q-header
    elevated
    class="layout-header z-top"
    :class="{ 'layout-header--sidebar-collapsed': sidebarCollapsed }"
  >
    <q-toolbar class="layout-header__toolbar">
      <q-btn
        v-if="showSidebarToggle"
        flat
        dense
        round
        icon="o_menu"
        :aria-label="sidebarCollapsed ? 'Развернуть меню' : 'Свернуть меню'"
        class="layout-header__sidebar-toggle"
        @click="$emit('sidebar-toggle', $event)"
      />

      <HeaderLeftArea
        :payment-balance="paymentBalance"
        :commission-balance="commissionBalance"
        :payment-label="paymentLabel"
        :commission-label="commissionLabel"
        @recharge-click="$emit('recharge-click', $event)"
        @notifications-click="$emit('notifications-click', $event)"
      />

      <q-toolbar-title v-if="title" class="layout-header__title layout-header__title--shrink">
        {{ title }}
      </q-toolbar-title>
      <slot v-else name="title" />

      <q-space />

      <HeaderRightArea
        :title="userTitle"
        :subtitle="userSubtitle"
        v-bind="userAvatar != null ? { avatar: userAvatar } : {}"
        @notifications-click="$emit('notifications-click', $event)"
      />
    </q-toolbar>
  </q-header>
</template>

<script setup lang="ts">
import HeaderLeftArea from './HeaderLeftArea.vue';
import HeaderRightArea from './HeaderRightArea.vue';

defineOptions({ name: 'LayoutHeader' });

withDefaults(
  defineProps<{
    sidebarCollapsed?: boolean;
    showSidebarToggle?: boolean;
    title?: string;
    paymentBalance?: number;
    commissionBalance?: number;
    paymentLabel?: string;
    commissionLabel?: string;
    userTitle?: string;
    userSubtitle?: string;
    userAvatar?: string;
  }>(),
  {
    sidebarCollapsed: false,
    showSidebarToggle: true,
    title: '',
    paymentBalance: 95000,
    commissionBalance: 5000,
    paymentLabel: 'Баланс для оплаты',
    commissionLabel: 'Баланс комиссии',
    userTitle: 'Пользователь',
    userSubtitle: 'Менеджер',
  },
);

defineEmits<{
  'sidebar-toggle': [event: Event];
  'recharge-click': [event: Event];
  'notifications-click': [event: Event];
}>();
</script>

<style scoped lang="scss">
.layout-header {
  background: var(--layout-header-bg);
  /* left/right/width — в app.scss (!important для override Quasar) */
}

.layout-header__toolbar {
  min-height: var(--layout-header-height);
  min-width: 0; /* позволяет flex-элементам сжиматься */
}

.layout-header__sidebar-toggle {
  margin-right: var(--layout-header-menu-gap);
  color: var(--color-primary-main) !important;

  :deep(.q-icon) {
    color: var(--color-primary-main) !important;
  }
}

.layout-header__title {
  font-size: var(--layout-header-title-font-size);
  font-weight: 500;
  color: var(--layout-header-title-color);

  &--shrink {
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
  }
}

/* HeaderRightArea не должен сжиматься */
.layout-header :deep(.header-right-area) {
  flex-shrink: 0;
}

/* HeaderLeftArea и title могут сжиматься при нехватке места */
.layout-header :deep(.header-left-area) {
  min-width: 0;
  flex-shrink: 1;
}

/* q-toolbar-title — сжимаем приоритетно */
.layout-header :deep(.q-toolbar__title) {
  min-width: 0 !important;
  flex-shrink: 1 !important;
}
</style>
