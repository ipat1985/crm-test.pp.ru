<template>
  <section class="integration-connections">
    <IntegrationToggleItem
      v-model="avitoEnabled"
      v-model:stages="avitoStages"
      site-name="Авито"
      :logo-src="avitoLogo"
      :stage-options="stageOptions"
    />

    <IntegrationToggleItem
      v-model="hhEnabled"
      v-model:stages="hhStages"
      site-name="HH.ru"
      :logo-src="hhLogo"
      :stage-options="stageOptions"
    />

    <button type="button" class="integration-connections__title-toggle" @click="siteFormEnabled = !siteFormEnabled">
      <span class="integration-connections__title-text">Форма на сайте</span>
      <ToggleIndicator :checked="siteFormEnabled" size="md" />
    </button>
    <CheckboxIntegration v-if="siteFormEnabled" />

    <button type="button" class="integration-connections__title-toggle" @click="vacanciesEnabled = !vacanciesEnabled">
      <span class="integration-connections__title-text">Вакансии</span>
      <ToggleIndicator :checked="vacanciesEnabled" size="md" />
    </button>
  </section>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import CheckboxIntegration from './CheckboxIntegration.vue';
import IntegrationToggleItem from './IntegrationToggleItem.vue';
import ToggleIndicator from './ToggleIndicator.vue';
import avitoLogo from 'src/assets/logos/avito-logo.svg';
import hhLogo from 'src/assets/logos/hh-logo.svg';

defineOptions({ name: 'IntegrationConnections' });

const avitoEnabled = ref(false);
const hhEnabled = ref(false);
const siteFormEnabled = ref(false);
const vacanciesEnabled = ref(false);
const avitoStages = ref<string[]>([]);
const hhStages = ref<string[]>([]);

const isValid = computed(() => avitoEnabled.value || hhEnabled.value || siteFormEnabled.value || vacanciesEnabled.value);

const enabledSources = computed(() => {
  const sources: Array<{ label: string; value: string }> = [];
  if (avitoEnabled.value) sources.push({ label: 'Авито', value: 'avito' });
  if (hhEnabled.value) sources.push({ label: 'HH.ru', value: 'hh' });
  if (siteFormEnabled.value) sources.push({ label: 'Форма на сайте', value: 'site-form' });
  if (vacanciesEnabled.value) sources.push({ label: 'Вакансии', value: 'vacancies' });
  return sources;
});

const allSources = computed(() => {
  return [
    { label: 'Авито', value: 'avito' },
    { label: 'HH.ru', value: 'hh' },
    { label: 'Форма на сайте', value: 'site-form' },
    { label: 'Вакансии', value: 'vacancies' },
  ];
});

defineExpose({
  isValid,
  enabledSources,
  allSources,
});

const stageOptions = [
  { label: '#грузчик', value: 'loader' },
  { label: '#упаковщик', value: 'packer' },
  { label: '#разнорабочий', value: 'laborer' },
  { label: '#курьер', value: 'courier' },
  { label: '#уборщик', value: 'cleaner' },
  { label: '#дворник', value: 'janitor' },
  { label: '#мойщик посуды', value: 'dishwasher' },
  { label: '#кассир', value: 'cashier' },
  { label: '#продавец', value: 'seller' },
  { label: '#кладовщик', value: 'storekeeper' },
  { label: '#комплектовщик', value: 'picker' },
  { label: '#сортировщик', value: 'sorter' },
  { label: '#оператор call-центра', value: 'call-center' },
  { label: '#сторож', value: 'guard' },
  { label: '#вахтер', value: 'concierge' },
  { label: '#фасовщик', value: 'portioner' },
  { label: '#мерчендайзер', value: 'merchandiser' },
  { label: '#промоутер', value: 'promoter' },
  { label: '#официант', value: 'waiter' },
  { label: '#бариста', value: 'barista' },
  { label: '#москва', value: 'moscow' },
  { label: '#санкт-петербург', value: 'saint-petersburg' },
  { label: '#новосибирск', value: 'novosibirsk' },
  { label: '#екатеринбург', value: 'yekaterinburg' },
  { label: '#казань', value: 'kazan' },
  { label: '#нижний_новгород', value: 'nizhny-novgorod' },
  { label: '#челябинск', value: 'chelyabinsk' },
  { label: '#самара', value: 'samara' },
  { label: '#омск', value: 'omsk' },
  { label: '#ростов-на-дону', value: 'rostov-on-don' },
];
</script>

<style scoped lang="scss">
.integration-connections {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.integration-connections__title-toggle {
  border: 0;
  background: transparent;
  padding: 16px 0 10px;
  width: 100%;
  display: inline-flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
}

.integration-connections__title-text {
  font-family: var(--font-family-roboto);
  font-size: 18px;
  line-height: 20px;
  font-weight: 700;
  color: #000;
}
</style>
