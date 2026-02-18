<template>
  <div class="page-content">
    <div class="page-content__surface" :class="surfaceClass">
      <template v-if="state === 'empty'">
        <p class="page-content__message">
          {{ emptyMessage }}
        </p>
        <a
          href="#"
          class="page-content__action"
          @click.prevent="$emit('action-click', $event)"
        >
          {{ emptyActionLabel }}
        </a>
      </template>

      <template v-else-if="isOrderFilled">
        <div class="page-content__filters">
          <div class="page-content__filter-list">
            <button
              v-for="item in filterLabels"
              :key="item"
              type="button"
              class="page-content__filter-chip"
            >
              <span>{{ item }}</span>
              <q-icon name="o_expand_more" size="16px" />
            </button>
          </div>

          <IconButton
            icon="o_filter_list"
            variant="outlined"
            shape="square"
            aria-label="Открыть фильтры"
            @click="$emit('filter-click', $event)"
          />
        </div>

        <div class="page-content__filled-body">
          <div class="page-content__table">
            <div class="page-content__table-row page-content__table-row--head">
              <div class="page-content__cell page-content__cell--check">
                <CheckboxIndicator size="xs" />
              </div>
              <div class="page-content__cell page-content__cell--head">
                <span>Клиент</span>
                <q-icon name="o_keyboard_arrow_down" size="18px" />
              </div>
              <div class="page-content__cell page-content__cell--head">
                <span>Объект</span>
                <q-icon name="o_keyboard_arrow_down" size="18px" />
              </div>
              <div class="page-content__cell page-content__cell--head">
                <span>Город</span>
                <q-icon name="o_keyboard_arrow_down" size="18px" />
              </div>
              <div class="page-content__cell page-content__cell--head">
                <span>Дней</span>
                <q-icon name="o_keyboard_arrow_down" size="18px" />
              </div>
              <div class="page-content__cell page-content__cell--head">
                <span>Человек</span>
                <q-icon name="o_keyboard_arrow_down" size="18px" />
              </div>
              <div class="page-content__cell page-content__cell--head">Часов</div>
              <div class="page-content__cell page-content__cell--head">Действия</div>
            </div>

            <div
              v-for="row in orderDemoRows"
              :key="row.id"
              class="page-content__table-row page-content__table-row--body"
            >
              <div class="page-content__cell page-content__cell--check">
                <CheckboxIndicator size="xs" />
              </div>
              <div class="page-content__cell">{{ row.client }}</div>
              <div class="page-content__cell page-content__cell--object">
                {{ row.object }}
              </div>
              <div class="page-content__cell">{{ row.city }}</div>
              <div class="page-content__cell">{{ row.days }}</div>
              <div class="page-content__cell">{{ row.people }}</div>
              <div class="page-content__cell">{{ row.hours }}</div>
              <div class="page-content__cell">
                <q-btn
                  icon="o_more_horiz"
                  round
                  dense
                  flat
                  size="sm"
                  color="primary"
                  aria-label="Действия"
                  class="page-content__more-btn"
                />
              </div>
            </div>
          </div>

          <slot />
        </div>
      </template>

      <template v-else>
        <slot />
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import IconButton from 'components/IconButton.vue';
import CheckboxIndicator from 'components/CheckboxIndicator.vue';

defineOptions({ name: 'PageContent' });

const props = withDefaults(
  defineProps<{
    page?: 'order' | 'task' | 'index';
    state?: 'empty' | 'filled';
  }>(),
  {
    page: 'order',
    state: 'empty',
  },
);

defineEmits<{
  'action-click': [event: Event];
  'filter-click': [event: Event];
}>();

const emptyContentByPage = {
  order: {
    message: 'Заявок пока нет.',
    action: 'Создать заявку',
  },
  task: {
    message: 'Заданий пока нет.',
    action: 'Создать задание',
  },
  index: {
    message: 'Это контент стартовой страницы',
    action: 'Добавить элемент',
  },
} as const;

const filterLabels = ['Клиент', 'Объект', 'Город', 'Дата начала работ'];

interface OrderDemoRow {
  id: number;
  client: string;
  object: string;
  city: string;
  days: number;
  people: number;
  hours: number;
}

function randomFrom<T>(items: T[]): T {
  return items[Math.floor(Math.random() * items.length)] as T;
}

function buildRandomOrderRows(count: number): OrderDemoRow[] {
  const clients = [
    'РиКо',
    'СтройСервис',
    'ТехПром',
    'ГородПроект',
    'ИнжГрупп',
    'МегаСтрой',
    'ГлобалИнвест',
    'СеверМонтаж',
    'ЮгИнжиниринг',
    'Сфера Девелопмент',
  ];

  const cities = [
    'Краснодар',
    'Сочи',
    'Ростов-на-Дону',
    'Новороссийск',
    'Туапсе',
    'Ставрополь',
    'Казань',
    'Екатеринбург',
    'Самара',
    'Воронеж',
  ];

  const objectNames = [
    'НПЗ «Горячий Ключ», Горячеключевская улица, 5',
    'Жилой комплекс «Солнечная Ривьера», корпус Б2, секция 4, внутренние инженерные сети',
    'Складской терминал класса A+, зона погрузки и логистический контур',
    'Торгово-деловой центр «Плаза Север», 3 очередь, блок 2',
    'Реконструкция производственного корпуса №7, административно-бытовой комплекс',
    'Спортивный многофункциональный кластер с подземным паркингом',
    'Объект капитального строительства, этап 2.1, сети водоснабжения и канализации',
    'Микрорайон «Лазурный Берег», литер 12, благоустройство и фасадные работы',
    'Аэропортовый грузовой хаб, технологическая зона сортировки',
    'Индустриальный парк «Восток», корпус C, монтаж слаботочных систем',
    'Котельная установка модульного типа для ЖК «Южный квартал»',
    'Бизнес-центр «Новый Горизонт», башня А, инженерный этаж',
  ];

  return Array.from({ length: count }, (_, index) => ({
    id: index + 1,
    client: randomFrom(clients),
    object: randomFrom(objectNames),
    city: randomFrom(cities),
    days: 1 + Math.floor(Math.random() * 14),
    people: 1 + Math.floor(Math.random() * 25),
    hours: 4 + Math.floor(Math.random() * 12),
  }));
}

const orderDemoRows = buildRandomOrderRows(20);

const emptyMessage = computed(() => emptyContentByPage[props.page].message);
const emptyActionLabel = computed(() => emptyContentByPage[props.page].action);
const isOrderFilled = computed(() => props.page === 'order' && props.state === 'filled');

const surfaceClass = computed(() => ({
  'page-content__surface--centered': props.state === 'empty',
}));
</script>

<style scoped lang="scss">
.page-content {
  display: flex;
  flex-direction: column;
  flex: 1 1 0;
  min-height: 0;
  width: 100%;
  overflow-y: auto;
}

.page-content__surface {
  display: flex;
  flex-direction: column;
  flex: 1 1 0;
  min-height: 0;
  width: 100%;
  background: var(--color-bg-surface);
  border-radius: 8px;
  padding: 24px;
  box-sizing: border-box;
}

.page-content__surface--centered {
  align-items: center;
  justify-content: center;
  text-align: center;
}

.page-content__message {
  margin: 0 0 12px 0;
  font-family: var(--font-family-fa);
  font-size: var(--order-empty-message-font-size);
  line-height: var(--order-empty-message-line-height);
  color: var(--color-text-secondary);
  font-weight: 400;
}

.page-content__action {
  font-family: var(--font-family-fa);
  font-size: var(--order-empty-action-font-size);
  line-height: var(--order-empty-action-line-height);
  color: var(--color-primary-main);
  font-weight: 400;
  text-decoration: underline;
  cursor: pointer;
  transition: color 0.2s;

  &:hover {
    color: var(--color-primary-dark);
  }
}

.page-content__filters {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.page-content__filter-list {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 0;
  flex-wrap: wrap;
}

.page-content__filter-chip {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  border: 1px solid var(--color-primary-main);
  background: var(--icon-btn-default-filled-bg);
  color: var(--color-primary-main);
  border-radius: 9999px;
  height: 28px;
  padding: 0 10px;
  font-size: 12px;
  line-height: 1;
  cursor: pointer;
}

.page-content__filled-body {
  flex: 1 1 0;
  min-height: 0;
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.page-content__table {
  display: flex;
  flex-direction: column;
  width: 100%;
  background: var(--color-bg-white);
}

.page-content__table-row {
  display: grid;
  grid-template-columns: 56px 140px minmax(260px, 1.8fr) 140px 90px 110px 90px 90px;
  width: 100%;
  align-items: center;
}

.page-content__table-row--head {
  background: #f6f6f9;
  min-height: 40px;
}

.page-content__table-row--body {
  min-height: 40px;
  border-bottom: 1px solid #ececfb;
}

.page-content__cell {
  min-height: 40px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 6px 8px;
  color: #000;
  font-family: var(--font-family-fa);
  font-size: 13px;
  line-height: 1.2;
  box-sizing: border-box;
}

.page-content__cell--head {
  font-size: 12px;
  font-weight: 500;
  gap: 4px;
}

.page-content__cell--check {
  justify-content: center;
}

.page-content__cell--object {
  justify-content: flex-start;
  text-align: left;
  white-space: normal;
  line-height: 1.25;
}

.page-content__more-btn {
  width: 24px;
  height: 24px;
  min-width: 24px;
}
</style>
