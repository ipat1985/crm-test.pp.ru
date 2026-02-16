<template>
  <div class="sidebar-scroll-area" :class="{ 'sidebar-scroll-area--collapsed': collapsed }">
    <q-scroll-area class="sidebar-scroll">
      <q-list class="sidebar-menu">
        <template v-for="entry in menuOrder" :key="entry.key">
          <!-- Single item (Level 1, Default, no Badge, no Children) -->
          <q-item
            v-if="entry.type === 'single'"
            clickable
            v-ripple
            :to="entry.to"
            :active="activeRoute === entry.to"
            active-class="sidebar-menu__item--active"
            class="sidebar-menu__item sidebar-menu__item--level-1"
          >
            <q-item-section avatar>
              <q-icon :name="entry.icon" class="sidebar-menu__icon" size="24px" />
            </q-item-section>
            <q-item-section v-show="!collapsed">
              <q-item-label class="sidebar-menu__label">{{ entry.title }}</q-item-label>
            </q-item-section>
          </q-item>

          <!-- Expandable group (Sidebar/MenuGroup) -->
          <template v-else>
            <!-- Свёрнутый: иконка + QMenu с подменю -->
            <div v-if="collapsed" class="sidebar-menu__group-wrapper">
              <q-item
                clickable
                v-ripple
                :class="['sidebar-menu__item', 'sidebar-menu__item--level-1', { 'sidebar-menu__item--active': entry.children.some((c) => c.to === activeRoute) || openedGroupKey === entry.key }]"
                @click="openGroupPopover($event, entry.key)"
              >
                <q-item-section avatar>
                  <q-icon :name="entry.icon" class="sidebar-menu__icon" size="24px" />
                </q-item-section>
              </q-item>
              <q-menu
                :model-value="openedGroupKey === entry.key"
                @update:model-value="(v) => !v && closeGroupPopover()"
                :target="popoverAnchorEl ?? undefined"
                anchor="top end"
                self="top start"
                class="sidebar-menu__popover"
                :offset="[4, 0]"
              >
                <SidebarMenuOverlay
                  :title="entry.title"
                  :children="entry.children"
                  :active-route="activeRoute"
                  @select="closeGroupPopover"
                />
              </q-menu>
            </div>
            <!-- Развёрнутый: обычный q-expansion-item -->
            <q-expansion-item
              v-else
              :icon="entry.icon"
              :label="entry.title"
              :header-class="['sidebar-menu__item', 'sidebar-menu__item--level-1', { 'sidebar-menu__item--active': entry.children.some((c) => c.to === activeRoute) }]"
              expand-icon-class="sidebar-menu__expand-icon"
              expand-icon="o_expand_more"
              expand-icon-size="24px"
              :default-opened="entry.children.some((c) => c.to === activeRoute)"
            >
              <q-list class="sidebar-menu__sublist">
                <q-item
                  v-for="child in entry.children"
                  :key="child.title"
                  clickable
                  v-ripple
                  :to="child.to"
                  :active="activeRoute === child.to"
                  active-class="sidebar-menu__subitem--active"
                  class="sidebar-menu__subitem"
                >
                  <q-item-section avatar class="min-width-0">
                    <q-icon :name="child.icon" class="sidebar-menu__subitem-icon" size="12px" />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label class="sidebar-menu__subitem-label">{{ child.title }}</q-item-label>
                  </q-item-section>
                </q-item>
              </q-list>
            </q-expansion-item>
          </template>
        </template>
      </q-list>
    </q-scroll-area>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import { useRoute } from 'vue-router';
import SidebarMenuOverlay from './SidebarMenuOverlay.vue';

const openedGroupKey = ref<string | null>(null);
const popoverAnchorEl = ref<HTMLElement | null>(null);

function openGroupPopover(event: Event, key: string) {
  const el = event.currentTarget as HTMLElement;
  if (el) popoverAnchorEl.value = el;
  openedGroupKey.value = openedGroupKey.value === key ? null : key;
}

function closeGroupPopover() {
  openedGroupKey.value = null;
}

export interface SidebarMenuItem {
  title: string;
  icon: string;
  to: string;
}

export interface SidebarMenuExpandableItem {
  title: string;
  icon: string;
  children: SidebarMenuItem[];
}

type MenuEntry =
  | { type: 'single'; key: string; title: string; icon: string; to: string }
  | ({ type: 'group'; key: string; title: string; icon: string; children: SidebarMenuItem[] });

defineProps<{
  collapsed: boolean;
}>();

const route = useRoute();
const activeRoute = computed(() => route.path);

// Порядок по макету Figma (node-id=5-192). Иконки outline: префикс o_ для material-icons-outlined
const menuOrder: MenuEntry[] = [
  { type: 'single', key: 'tasks', title: 'Задания', icon: 'o_task_alt', to: '/tasks' },
  { type: 'single', key: 'applications', title: 'Заявки', icon: 'o_list_alt', to: '/applications' },
  {
    type: 'group',
    key: 'shifts',
    title: 'Смены',
    icon: 'o_featured_play_list',
    children: [
      { title: 'Сбор откликов', icon: 'o_radio_button_unchecked', to: '/shifts/collecting' },
      { title: 'В работе', icon: 'o_radio_button_unchecked', to: '/shifts/in-progress' },
      { title: 'Согласование времени', icon: 'o_radio_button_unchecked', to: '/shifts/approval' },
      { title: 'В оплате', icon: 'o_radio_button_unchecked', to: '/shifts/payment' },
      { title: 'Архив', icon: 'o_radio_button_unchecked', to: '/shifts/archive' },
      { title: 'Отмененные', icon: 'o_radio_button_unchecked', to: '/shifts/canceled' },
    ],
  },
  {
    type: 'group',
    key: 'clients',
    title: 'Клиенты',
    icon: 'o_handshake',
    children: [
      { title: 'База клиентов', icon: 'o_radio_button_unchecked', to: '/clients/database' },
      { title: 'Выставление счетов', icon: 'o_radio_button_unchecked', to: '/clients/invoicing' },
      { title: 'Выписанные счета', icon: 'o_radio_button_unchecked', to: '/clients/invoices' },
      { title: 'Отчет о зачислениях', icon: 'o_radio_button_unchecked', to: '/clients/report' },
    ],
  },
  {
    type: 'group',
    key: 'workers',
    title: 'Работники',
    icon: 'o_person_pin',
    children: [
      { title: 'База работников', icon: 'o_radio_button_unchecked', to: '/workers/database' },
      { title: 'Верификация работников', icon: 'o_radio_button_unchecked', to: '/workers/verification' },
      { title: 'Верификация медицинских карт', icon: 'o_radio_button_unchecked', to: '/workers/medical' },
      { title: 'Верификация СНИЛС', icon: 'o_radio_button_unchecked', to: '/workers/snils' },
      { title: 'Теги работников', icon: 'o_radio_button_unchecked', to: '/workers/tags' },
      { title: 'Профессии', icon: 'o_radio_button_unchecked', to: '/workers/professions' },
      { title: 'Налоговый кабинет', icon: 'o_radio_button_unchecked', to: '/workers/tax' },
      { title: 'Уведомления иностранцев', icon: 'o_radio_button_unchecked', to: '/workers/notifications' },
      { title: 'Рассылка', icon: 'o_radio_button_unchecked', to: '/workers/mailing' },
    ],
  },
  {
    type: 'group',
    key: 'users',
    title: 'Пользователи',
    icon: 'o_sensor_occupied',
    children: [
      { title: 'Операторы клиентов', icon: 'o_radio_button_unchecked', to: '/users/client-operators' },
      { title: 'Операторы партнеров', icon: 'o_radio_button_unchecked', to: '/users/partner-operators' },
    ],
  },
  {
    type: 'group',
    key: 'risks',
    title: 'Риски бизнеса',
    icon: 'o_warning_amber',
    children: [
      { title: 'Аннулированные чеки', icon: 'o_radio_button_unchecked', to: '/risks/checks' },
      { title: 'Стоп-лист', icon: 'o_radio_button_unchecked', to: '/risks/stoplist' },
    ],
  },
  {
    type: 'group',
    key: 'recruitment',
    title: 'Рекрутинг',
    icon: 'o_folder_shared',
    children: [
      { title: 'Органический трафик', icon: 'o_radio_button_unchecked', to: '/recruitment/organic' },
      { title: 'Вакансии', icon: 'o_radio_button_unchecked', to: '/recruitment/vacancies' },
      { title: 'Заявка на подбор', icon: 'o_radio_button_unchecked', to: '/recruitment/request' },
      { title: 'Календарь собеседований', icon: 'o_radio_button_unchecked', to: '/recruitment/calendar' },
      { title: 'Статистика', icon: 'o_radio_button_unchecked', to: '/recruitment/stats' },
      { title: 'Настройка', icon: 'o_radio_button_unchecked', to: '/recruitment/settings' },
    ],
  },
  { type: 'single', key: 'exports', title: 'Выгрузки', icon: 'o_drive_folder_upload', to: '/exports' },
  { type: 'single', key: 'integrations', title: 'Интеграции', icon: 'o_integration_instructions', to: '/integrations' },
  {
    type: 'group',
    key: 'documents',
    title: 'Документы',
    icon: 'o_assignment',
    children: [
      { title: 'Договоры с клиентами', icon: 'o_radio_button_unchecked', to: '/documents/client-contracts' },
      { title: 'Договоры с работниками', icon: 'o_radio_button_unchecked', to: '/documents/worker-contracts' },
      { title: 'Акты самозанятых', icon: 'o_radio_button_unchecked', to: '/documents/self-employed-acts' },
    ],
  },
  {
    type: 'group',
    key: 'news',
    title: 'Новости / обновления',
    icon: 'o_newspaper',
    children: [
      { title: 'Новости', icon: 'o_radio_button_unchecked', to: '/news/news' },
      { title: 'Обновления', icon: 'o_radio_button_unchecked', to: '/news/updates' },
    ],
  },
];
</script>

<style scoped lang="scss">
.sidebar-scroll-area {
  flex: 1;
  min-height: 0;
}

.sidebar-scroll {
  height: 100%;

  :deep(.q-scrollarea__content) {
    display: block;
  }
}

.sidebar-menu {
  padding: 8px var(--sidebar-menu-padding-x);

  /* Свёрнутый sidebar: одинаковые отступы вокруг иконок */
  .sidebar-scroll-area--collapsed & {
    padding: var(--sidebar-collapsed-icon-padding);
  }

  /* Иконки пунктов меню: 24×24px */
  :deep(.sidebar-menu__icon),
  :deep(.sidebar-menu__item .q-item__section--avatar .q-icon),
  :deep(.sidebar-menu__expand-icon) {
    font-size: var(--sidebar-icon-size) !important;
  }

  /* Расстояние от иконки до названия — MenuItem и MenuGroup */
  :deep(.sidebar-menu__item .q-item__section--avatar),
  :deep(.q-expansion-item .q-item__section--avatar) {
    min-width: calc(var(--sidebar-icon-size) + var(--sidebar-menu-icon-gap)) !important;
  }

  /* Свёрнутый: avatar только по размеру иконки, центр по padding */
  .sidebar-scroll-area--collapsed & :deep(.sidebar-menu__item .q-item__section--avatar),
  .sidebar-scroll-area--collapsed & :deep(.q-expansion-item .q-item__section--avatar) {
    min-width: var(--sidebar-icon-size) !important;
  }

  :deep(.sidebar-menu__subitem .q-item__section--avatar) {
    min-width: calc(var(--sidebar-subitem-icon-size) + var(--sidebar-menu-icon-gap)) !important;
  }

  /* Иконки подпунктов: 12×12px */
  :deep(.sidebar-menu__subitem-icon) {
    font-size: var(--sidebar-subitem-icon-size) !important;
  }

  /* MenuGroup: скругление и hover как у MenuItem */
  :deep(.q-expansion-item > .q-expansion-item__container > .q-item) {
    margin: 0 0 4px 0;
    border-radius: var(--sidebar-menu-item-radius);
    overflow: hidden;

    &:hover {
      background: var(--sidebar-menu-item-hover-bg);
    }

    /* Свёрнутый: одинаковые отступы со всех сторон */
    .sidebar-scroll-area--collapsed & {
      justify-content: center;
      padding: var(--sidebar-collapsed-icon-padding) !important;
    }
  }

  /* Раскрытая группа (не selected): фон, текст/иконки — макет 18-801 */
  :deep(.q-expansion-item--expanded > .q-expansion-item__container > .q-item:not(.sidebar-menu__item--active)) {
    background: var(--sidebar-menu-group-expanded-bg);

    .q-item__label,
    .q-icon {
      color: var(--sidebar-menu-group-expanded-text);
    }

    .sidebar-menu__expand-icon {
      color: var(--sidebar-menu-group-expanded-icon);
    }
  }

  /* Единый цвет для single и expandable: переопределяем Quasar defaults */
  :deep(.sidebar-menu__item--level-1) {
    .q-item__label,
    .q-item__section .q-icon,
    .q-item__section--avatar .q-icon,
    .q-item__section--side .q-icon,
    .q-expansion-item__toggle-icon {
      color: var(--sidebar-menu-item-text) !important;
    }

    .q-item__label {
      font-size: 14px;
      font-weight: 500;
    }
  }

  &__item {
    margin: 0 0 4px 0;
    border-radius: var(--sidebar-menu-item-radius);
    overflow: hidden;

    /* Свёрнутый: одинаковые отступы со всех сторон, иконка по центру */
    .sidebar-scroll-area--collapsed & {
      justify-content: center;
      padding: var(--sidebar-collapsed-icon-padding) !important;
    }

    /* Hover: primary-o-light по макету 30:52884 */
    &:hover {
      background: var(--sidebar-menu-item-hover-bg);
    }

    /* Выбранный пункт (текущая страница): сплошной primary, белый текст */
    &--active {
      background: var(--sidebar-menu-item-active-bg);

      :deep(.q-item__label),
      :deep(.q-icon),
      :deep(.sidebar-menu__expand-icon) {
        color: var(--sidebar-menu-item-active-text) !important;
      }
    }
  }

  &__icon {
    color: var(--sidebar-menu-item-icon);
  }

  &__label {
    color: var(--sidebar-menu-item-text);
  }

  &__expand-icon {
    color: var(--sidebar-menu-item-expand-icon);
  }

  &__sublist {
    padding-left: 0;
  }

  &__subitem {
    padding-left: 24px;
    min-height: 36px;
    margin: 0 0 2px 0;
    border-radius: var(--sidebar-menu-item-radius);
    overflow: hidden;

    &:hover {
      background: var(--sidebar-menu-item-hover-bg);
    }

    &--active .sidebar-menu__subitem-label {
      color: var(--sidebar-subitem-active-text);
      font-weight: 500;
    }

    &--active .sidebar-menu__subitem-icon {
      color: var(--sidebar-subitem-active-icon);
    }
  }

  &__subitem-label {
    font-size: 14px;
    color: var(--sidebar-subitem-text);
  }

  &__subitem-icon {
    color: var(--sidebar-subitem-icon);
  }

  /* Popover подменю при свёрнутом sidebar */
  &__group-wrapper {
    position: relative;
  }
}
</style>

<style lang="scss">
/* QMenu teleport — стили вне scoped */
.sidebar-menu__popover {
  padding: 0;
  overflow: visible;
}
</style>
