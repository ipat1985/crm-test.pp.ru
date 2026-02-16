<template>
  <q-layout view="lHh Lpr lFf">
    <Header
      :sidebar-collapsed="sidebarCollapsed"
      show-sidebar-toggle
      :payment-balance="95000"
      :commission-balance="5000"
      user-title="Пользователь"
      user-subtitle="Менеджер"
      @sidebar-toggle="toggleSidebarCollapsed"
      @recharge-click="onRechargeClick"
      @notifications-click="onNotificationsClick"
    />

    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      bordered
      :width="280"
      :mini="sidebarCollapsed"
      mini-to-overlay
      :mini-width="72"
    >
      <Sidebar :collapsed="sidebarCollapsed" @toggle="toggleSidebarCollapsed" />
    </q-drawer>

    <q-page-container
      class="layout-page-content"
      :class="{ 'layout-page-content--sidebar-collapsed': sidebarCollapsed }"
    >
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Header from 'components/layout/header/Header.vue';
import Sidebar from 'components/layout/sidebar/Sidebar.vue';

const leftDrawerOpen = ref(true); // show-if-above: всегда открыт на desktop
const sidebarCollapsed = ref(false);

function toggleSidebarCollapsed() {
  sidebarCollapsed.value = !sidebarCollapsed.value;
}

function onRechargeClick() {
  // TODO: open recharge modal
}

function onNotificationsClick() {
  // TODO: open notifications
}
</script>
