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
              v-for="filter in filterDefs"
              :key="filter.key"
              type="button"
              class="page-content__filter-chip"
              :class="{
                'page-content__filter-chip--selected': filterHasSelection(filter.key),
                'page-content__filter-chip--open': filterMenuOpen[filter.key],
              }"
            >
              <div class="page-content__filter-chip-main">
                <span class="page-content__filter-chip-label">{{ filter.label }}</span>

                <span class="page-content__filter-chip-actions">
                  <q-icon
                    v-if="showFilterClearIcon(filter.key)"
                    name="o_close"
                    size="16px"
                    class="page-content__filter-chip-clear"
                    @click.stop.prevent="clearFilter(filter.key)"
                  />
                  <q-icon
                    :name="filterMenuOpen[filter.key] ? 'o_expand_less' : 'o_expand_more'"
                    size="18px"
                  />
                </span>
              </div>

              <div v-if="filterHasSelection(filter.key)" class="page-content__filter-chip-values">
                <span
                  v-for="value in filterPreviewValues(filter.key)"
                  :key="`${filter.key}-${value}`"
                  class="page-content__filter-chip-value"
                  @click.stop.prevent="removeFilterValue(filter.key, value)"
                >
                  <span class="page-content__filter-chip-value-text">{{ value }}</span>
                  <q-icon name="o_close" size="14px" />
                </span>

                <span v-if="filterHiddenCount(filter.key) > 0" class="page-content__filter-chip-more">
                  +{{ filterHiddenCount(filter.key) }}
                </span>
              </div>

              <q-menu
                v-model="filterMenuOpen[filter.key]"
                class="page-content__filter-menu"
                anchor="bottom left"
                self="top left"
              >
                <div class="page-content__filter-menu-content">
                  <q-input
                    v-model="filterSearch[filter.key]"
                    dense
                    borderless
                    placeholder="Поиск..."
                    class="page-content__filter-search"
                  >
                    <template #prepend>
                      <q-icon name="o_search" size="20px" />
                    </template>
                  </q-input>

                  <button
                    v-for="option in visibleFilterOptions(filter.key)"
                    :key="option"
                    type="button"
                    class="page-content__filter-option"
                    @click.stop="toggleFilterOption(filter.key, option)"
                  >
                    <CheckboxIndicator
                      size="sm"
                      :checked="selectedFilters[filter.key].includes(option)"
                    />
                    <span class="page-content__filter-option-text">{{ option }}</span>
                  </button>
                </div>
              </q-menu>
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
                <button
                  type="button"
                  class="page-content__check-btn"
                  aria-label="Выбрать все строки"
                  @click.stop="toggleSelectAll"
                >
                  <CheckboxIndicator
                    size="sm"
                    class="page-content__table-checkbox"
                    :checked="allRowsSelected"
                    :indeterminate="hasPartialSelection"
                  />
                </button>
              </div>
              <div class="page-content__cell page-content__cell--head">
                <button type="button" class="page-content__head-btn" @click="toggleSort('client')">
                  <span>Клиент</span>
                  <q-icon :name="sortIconName('client')" :class="sortIconClass('client')" size="18px" />
                </button>
              </div>
              <div class="page-content__cell page-content__cell--head">
                <button type="button" class="page-content__head-btn" @click="toggleSort('object')">
                  <span>Объект</span>
                  <q-icon :name="sortIconName('object')" :class="sortIconClass('object')" size="18px" />
                </button>
              </div>
              <div class="page-content__cell page-content__cell--head">
                <button type="button" class="page-content__head-btn" @click="toggleSort('city')">
                  <span>Город</span>
                  <q-icon :name="sortIconName('city')" :class="sortIconClass('city')" size="18px" />
                </button>
              </div>
              <div class="page-content__cell page-content__cell--head">
                <button type="button" class="page-content__head-btn" @click="toggleSort('date')">
                  <span>Дата</span>
                  <q-icon :name="sortIconName('date')" :class="sortIconClass('date')" size="18px" />
                </button>
              </div>
              <div class="page-content__cell page-content__cell--head">
                <button type="button" class="page-content__head-btn" @click="toggleSort('days')">
                  <span>Дней</span>
                  <q-icon :name="sortIconName('days')" :class="sortIconClass('days')" size="18px" />
                </button>
              </div>
              <div class="page-content__cell page-content__cell--head">
                <button type="button" class="page-content__head-btn" @click="toggleSort('people')">
                  <span>Человек</span>
                  <q-icon :name="sortIconName('people')" :class="sortIconClass('people')" size="18px" />
                </button>
              </div>
              <div class="page-content__cell page-content__cell--head">
                <button type="button" class="page-content__head-btn" @click="toggleSort('hours')">
                  <span>Часов</span>
                  <q-icon :name="sortIconName('hours')" :class="sortIconClass('hours')" size="18px" />
                </button>
              </div>
              <div class="page-content__cell page-content__cell--head">Действия</div>
            </div>

            <div
              v-for="row in sortedOrderRows"
              :key="row.id"
              class="page-content__table-row page-content__table-row--body"
              :class="{ 'page-content__table-row--selected': isRowSelected(row.id) }"
              @click="toggleRowSelection(row.id)"
            >
              <div class="page-content__cell page-content__cell--check">
                <button
                  type="button"
                  class="page-content__check-btn"
                  :aria-label="`Выбрать заявку ${row.id}`"
                  @click.stop="toggleRowSelection(row.id)"
                >
                  <CheckboxIndicator
                    size="sm"
                    class="page-content__table-checkbox"
                    :checked="isRowSelected(row.id)"
                  />
                </button>
              </div>
              <div class="page-content__cell">{{ row.client }}</div>
              <div class="page-content__cell page-content__cell--object">
                {{ row.object }}
              </div>
              <div class="page-content__cell">{{ row.city }}</div>
              <div class="page-content__cell">{{ row.date }}</div>
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
                  @click.stop
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
import { computed, ref } from 'vue';
import IconButton from 'components/IconButton.vue';
import CheckboxIndicator from 'components/CheckboxIndicator.vue';

defineOptions({ name: 'PageContent' });

const props = withDefaults(
  defineProps<{
    page?: 'order' | 'task' | 'index' | 'recruitment-request';
    state?: 'empty' | 'filled';
    searchQuery?: string;
  }>(),
  {
    page: 'order',
    state: 'empty',
    searchQuery: '',
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
  'recruitment-request': {
    message: 'Заявок на подбор пока нет.',
    action: 'Создать заявку на подбор',
  },
} as const;

type FilterKey = 'client' | 'object' | 'city' | 'date';
type SortKey = 'client' | 'object' | 'city' | 'date' | 'days' | 'people' | 'hours';
type SortOrder = 'asc' | 'desc';

const filterDefs: Array<{ key: FilterKey; label: string }> = [
  { key: 'client', label: 'Клиент' },
  { key: 'object', label: 'Объект' },
  { key: 'city', label: 'Город' },
  { key: 'date', label: 'Дата начала работ' },
];

interface OrderDemoRow {
  id: number;
  client: string;
  object: string;
  city: string;
  date: string;
  dateSort: number;
  days: number;
  people: number;
  hours: number;
}

function randomFrom<T>(items: T[]): T {
  return items[Math.floor(Math.random() * items.length)] as T;
}

function randomDateInRange(start: Date, end: Date): Date {
  const min = start.getTime();
  const max = end.getTime();
  return new Date(min + Math.floor(Math.random() * (max - min)));
}

function formatDate(date: Date): string {
  const dd = String(date.getDate()).padStart(2, '0');
  const mm = String(date.getMonth() + 1).padStart(2, '0');
  const yyyy = date.getFullYear();
  return `${dd}.${mm}.${yyyy}`;
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

  return Array.from({ length: count }, (_, index) => {
    const date = randomDateInRange(new Date(2024, 0, 1), new Date(2026, 11, 31));

    return {
      id: index + 1,
      client: randomFrom(clients),
      object: randomFrom(objectNames),
      city: randomFrom(cities),
      date: formatDate(date),
      dateSort: date.getTime(),
      days: 1 + Math.floor(Math.random() * 14),
      people: 1 + Math.floor(Math.random() * 25),
      hours: 4 + Math.floor(Math.random() * 12),
    };
  });
}

const orderDemoRows = buildRandomOrderRows(20);
const sortBy = ref<SortKey>('date');
const sortOrder = ref<SortOrder>('desc');
const selectedRowIds = ref<number[]>([]);
const filterMenuOpen = ref<Record<FilterKey, boolean>>({
  client: false,
  object: false,
  city: false,
  date: false,
});
const filterSearch = ref<Record<FilterKey, string>>({
  client: '',
  object: '',
  city: '',
  date: '',
});
const selectedFilters = ref<Record<FilterKey, string[]>>({
  client: [],
  object: [],
  city: [],
  date: [],
});

function parseDateValue(value: string): number {
  const parts = value.split('.');
  if (parts.length !== 3) return 0;
  const dd = Number(parts[0] ?? 0);
  const mm = Number(parts[1] ?? 0);
  const yyyy = Number(parts[2] ?? 0);
  if (!Number.isFinite(dd) || !Number.isFinite(mm) || !Number.isFinite(yyyy)) return 0;
  return new Date(yyyy, mm - 1, dd).getTime();
}

function sortFilterValues(key: FilterKey, values: string[]): string[] {
  if (key === 'date') {
    return [...values].sort((a, b) => parseDateValue(a) - parseDateValue(b));
  }
  return [...values].sort((a, b) => a.localeCompare(b, 'ru'));
}

function buildOptionsForKey(key: FilterKey, rows: OrderDemoRow[]): string[] {
  return sortFilterValues(
    key,
    [...new Set(rows.map((row) => row[key]))],
  );
}

function normalizeSearchValue(value: string): string {
  return value.trim().toLowerCase();
}

function rowMatchesHeaderSearch(row: OrderDemoRow): boolean {
  const query = normalizeSearchValue(props.searchQuery);
  if (!query) return true;

  return (
    row.client.toLowerCase().includes(query) ||
    row.city.toLowerCase().includes(query) ||
    row.object.toLowerCase().includes(query)
  );
}

function rowsMatchingOtherFilters(key: FilterKey): OrderDemoRow[] {
  return orderDemoRows.filter((row) =>
    rowMatchesHeaderSearch(row) &&
    filterDefs.every((filter) => {
      if (filter.key === key) return true;
      const selected = selectedFilters.value[filter.key];
      if (selected.length === 0) return true;
      return selected.includes(row[filter.key]);
    }),
  );
}

const filterOptions = computed<Record<FilterKey, string[]>>(() => {
  const result = {} as Record<FilterKey, string[]>;

  filterDefs.forEach((filter) => {
    const dynamicOptions = buildOptionsForKey(filter.key, rowsMatchingOtherFilters(filter.key));
    const selected = selectedFilters.value[filter.key];
    result[filter.key] = sortFilterValues(
      filter.key,
      [...new Set([...dynamicOptions, ...selected])],
    );
  });

  return result;
});

const filteredOrderRows = computed(() =>
  orderDemoRows.filter((row) =>
    rowMatchesHeaderSearch(row) &&
    filterDefs.every((filter) => {
      const selected = selectedFilters.value[filter.key];
      if (selected.length === 0) return true;
      return selected.includes(row[filter.key]);
    }),
  ),
);

const sortedOrderRows = computed(() => {
  const rows = [...filteredOrderRows.value];
  const factor = sortOrder.value === 'asc' ? 1 : -1;

  return rows.sort((a, b) => {
    switch (sortBy.value) {
      case 'client':
      case 'object':
      case 'city':
        return a[sortBy.value].localeCompare(b[sortBy.value], 'ru') * factor;
      case 'date':
        return (a.dateSort - b.dateSort) * factor;
      case 'days':
      case 'people':
      case 'hours':
        return (a[sortBy.value] - b[sortBy.value]) * factor;
      default:
        return 0;
    }
  });
});

const allRowsSelected = computed(
  () =>
    sortedOrderRows.value.length > 0 &&
    sortedOrderRows.value.every((row) => selectedRowIds.value.includes(row.id)),
);

const hasPartialSelection = computed(
  () => {
    const visibleIds = sortedOrderRows.value.map((row) => row.id);
    const selectedVisibleCount = visibleIds.filter((id) => selectedRowIds.value.includes(id)).length;
    return selectedVisibleCount > 0 && selectedVisibleCount < visibleIds.length;
  },
);

function toggleSort(key: SortKey): void {
  if (sortBy.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
    return;
  }
  sortBy.value = key;
  sortOrder.value = 'asc';
}

function isRowSelected(id: number): boolean {
  return selectedRowIds.value.includes(id);
}

function toggleRowSelection(id: number): void {
  if (isRowSelected(id)) {
    selectedRowIds.value = selectedRowIds.value.filter((item) => item !== id);
    return;
  }
  selectedRowIds.value = [...selectedRowIds.value, id];
}

function toggleSelectAll(): void {
  if (allRowsSelected.value) {
    const visibleIds = new Set(sortedOrderRows.value.map((row) => row.id));
    selectedRowIds.value = selectedRowIds.value.filter((id) => !visibleIds.has(id));
    return;
  }
  const merged = new Set<number>([
    ...selectedRowIds.value,
    ...sortedOrderRows.value.map((row) => row.id),
  ]);
  selectedRowIds.value = Array.from(merged);
}

function sortIconName(key: SortKey): string {
  return sortBy.value === key && sortOrder.value === 'asc'
    ? 'o_keyboard_arrow_up'
    : 'o_keyboard_arrow_down';
}

function sortIconClass(key: SortKey): string {
  return sortBy.value === key ? 'page-content__head-icon--active' : '';
}

function visibleFilterOptions(key: FilterKey): string[] {
  const query = filterSearch.value[key].trim().toLowerCase();
  if (!query) return filterOptions.value[key];
  return filterOptions.value[key].filter((item) => item.toLowerCase().includes(query));
}

function toggleFilterOption(key: FilterKey, option: string): void {
  const selected = selectedFilters.value[key];
  if (selected.includes(option)) {
    selectedFilters.value[key] = selected.filter((item) => item !== option);
    return;
  }
  selectedFilters.value[key] = [...selected, option];
}

function filterHasSelection(key: FilterKey): boolean {
  return selectedFilters.value[key].length > 0;
}

function filterPreviewValues(key: FilterKey): string[] {
  return selectedFilters.value[key].slice(0, 1);
}

function filterHiddenCount(key: FilterKey): number {
  const count = selectedFilters.value[key].length - 1;
  return count > 0 ? count : 0;
}

function showFilterClearIcon(key: FilterKey): boolean {
  return selectedFilters.value[key].length > 1;
}

function clearFilter(key: FilterKey): void {
  selectedFilters.value[key] = [];
}

function removeFilterValue(key: FilterKey, value: string): void {
  selectedFilters.value[key] = selectedFilters.value[key].filter((item) => item !== value);
}

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
  overflow: hidden;
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
  overflow: hidden;
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
  gap: 16px;
  min-width: 0;
  flex-wrap: nowrap;
  overflow-x: auto;
}

.page-content__filter-chip {
  position: relative;
  display: inline-flex;
  flex-direction: column;
  align-items: stretch;
  justify-content: center;
  gap: 2px;
  width: fit-content;
  max-width: 100%;
  min-height: 56px;
  border: 1px solid transparent;
  background: transparent;
  color: var(--color-primary-main);
  border-radius: 10px;
  padding: 8px 14px;
  font-family: var(--font-family-fa);
  font-size: 16px;
  line-height: 1.25;
  cursor: pointer;
  transition:
    background-color 0.18s ease,
    border-color 0.18s ease,
    box-shadow 0.18s ease;

  &:hover {
    background: var(--color-primary-opacity-lighter);
  }
}

.page-content__filter-chip--open {
  background: var(--color-primary-opacity-lighter);
  border-color: #dcdcf7;
}

.page-content__filter-chip--selected {
  align-items: stretch;
  background: transparent;
  border-color: transparent;
}

.page-content__filter-chip-main {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  gap: 8px;
}

.page-content__filter-chip-label {
  font-family: var(--font-family-fa);
  font-size: 16px;
  line-height: 1.25;
  color: var(--color-primary-main);
  white-space: nowrap;
}

.page-content__filter-chip-actions {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 2px;
  flex-shrink: 0;
  min-width: 38px;
}

.page-content__filter-chip-clear {
  border-radius: 50%;

  &:hover {
    background: rgba(115, 103, 240, 0.12);
  }
}

.page-content__filter-chip-values {
  display: flex;
  align-items: center;
  gap: 6px;
  min-width: 0;
}

.page-content__filter-chip-value {
  max-width: 150px;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  border-radius: 4px;
  padding: 0 6px;
  height: 22px;
  background: #7367f0;
  color: #fff;
  font-size: 12px;
  line-height: 1;
}

.page-content__filter-chip-value-text {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.page-content__filter-chip-more {
  color: var(--color-primary-main);
  font-size: 12px;
  line-height: 1;
}

.page-content__filter-menu {
  border-radius: 10px;
}

.page-content__filter-menu-content {
  width: 300px;
  padding: 4px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.page-content__filter-search {
  background: var(--color-action-selected);
  border-radius: 10px;
  padding: 8px 10px;
}

.page-content__filter-option {
  border: 0;
  background: transparent;
  border-radius: 6px;
  min-height: 40px;
  padding: 8px 12px;
  display: flex;
  align-items: center;
  gap: 12px;
  text-align: left;
  cursor: pointer;

  &:hover {
    background: var(--color-action-hover);
  }
}

.page-content__filter-option-text {
  color: var(--color-text-primary);
  font-size: 16px;
  line-height: 1.5;
}

.page-content__filled-body {
  flex: 1 1 0;
  min-height: 0;
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  overflow: auto;
}

.page-content__table {
  display: flex;
  flex-direction: column;
  min-width: 100%;
  background: var(--color-bg-white);
}

.page-content__table-row {
  display: grid;
  grid-template-columns: 56px 140px minmax(260px, 1.6fr) 120px 120px 90px 110px 90px 90px;
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

.page-content__table-row--selected {
  background: var(--color-primary-o-light);
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
}

.page-content__head-btn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  border: 0;
  background: transparent;
  color: inherit;
  font: inherit;
  cursor: pointer;
  padding: 0;
}

.page-content__head-icon--active {
  color: var(--color-primary-main);
}

.page-content__cell--check {
  justify-content: center;
}

.page-content__check-btn {
  border: 0;
  background: transparent;
  padding: 0;
  margin: 0;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.page-content__table-checkbox {
  transform: scale(1.5);
  transform-origin: center;
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
