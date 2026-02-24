<template>
  <section class="form-order-content">
    <template v-if="section === 'description'">
      <h3 class="form-order-content__title">Основная информация</h3>

      <div class="form-order-content__row form-order-content__row--header">
        <InputTextfieldCustom
          v-model="titleModel"
          label="Название заявки *"
          class="form-order-content__field"
        />

        <Toggle
          v-model="isPrivate"
          label="Режим приватности"
          description=""
          size="md"
        />
      </div>

      <div class="form-order-content__row form-order-content__row--three">
        <InputSelectCustom
          v-model="city"
          label="Город *"
          :options="cityOptions"
          :leading-icon="''"
          :clearable="false"
          class="form-order-content__field"
        />
        <InputSelectCustom
          v-model="address"
          label="Адрес *"
          :options="addressOptions"
          :leading-icon="''"
          :clearable="false"
          class="form-order-content__field"
        />

        <div ref="closeDateAnchorRef" class="form-order-content__field">
          <InputTextfieldCustom
            v-model="closeDate"
            label="Дата закрытия *"
            readonly
            :force-focused="showDateMenu"
            class="form-order-content__field"
            @click="openDateMenu"
          >
            <template #append>
              <q-icon
                v-if="closeDate"
                name="o_close"
                class="cursor-pointer form-order-content__date-icon"
                @click.stop="clearCloseDate"
              />
              <q-icon
                v-else
                name="o_calendar_today"
                class="cursor-pointer form-order-content__date-icon"
                @click.stop="openDateMenu"
              />
            </template>
          </InputTextfieldCustom>

          <q-menu
            v-model="showDateMenu"
            :target="closeDateMenuTarget"
            anchor="bottom left"
            self="top left"
            :offset="[0, 8]"
            no-parent-event
            :style="closeDateMenuStyle"
            class="form-order-content__date-menu"
          >
            <q-date
              v-model="closeDate"
              mask="DD.MM.YYYY"
              minimal
              :options="isSelectableCloseDate"
              @update:model-value="showDateMenu = false"
            />
          </q-menu>
        </div>
      </div>

      <h3 class="form-order-content__title">Ответственные лица</h3>

      <div class="form-order-content__row form-order-content__row--contacts">
        <InputTextfieldCustom
          v-model="contactName"
          label="Контактное лицо"
          class="form-order-content__field"
        />
        <InputPhoneCustom
          v-model="contactPhone"
          label="Телефон"
          class="form-order-content__field"
        />
        <Toggle
          v-model="hideContacts"
          label="Скрыть контакты"
          description=""
          size="md"
        />
      </div>

      <h3 class="form-order-content__title">Описание</h3>

      <InputTextfieldCustom
        v-model="description"
        type="textarea"
        label=""
        placeholder="Детали заявки"
        auto-grow
        :min-rows="5"
        :max-rows="5"
        class="form-order-content__textarea"
      />

      <div class="form-order-content__footer">
        <Button label="Отменить" variant="outline" size="md" class="form-order-content__soft-btn" @click="$emit('cancel')" />
        <Button label="Далее" variant="fill" size="md" :disabled="!isFormValid" @click="onNextClick" />
      </div>
    </template>

    <template v-else>
      <template v-if="section === 'requirements'">
        <h3 class="form-order-content__title">Условия</h3>

        <div class="form-order-content__row form-order-content__row--three">
          <InputSelectCustom
            v-model="jobServiceType"
            label="Услуга / Тип работ"
            :options="jobServiceTypeOptions"
            :leading-icon="''"
            :clearable="false"
            class="form-order-content__field"
          />
          <InputSelectCustom
            v-model="positionsCount"
            label="Количество позиций *"
            :options="positionsCountOptions"
            :leading-icon="''"
            :clearable="false"
            class="form-order-content__field"
          />
          <InputSelectCustom
            v-model="workSchedule"
            label="График"
            :options="workScheduleOptions"
            :leading-icon="''"
            :clearable="false"
            class="form-order-content__field"
          />
        </div>

        <div class="form-order-content__row form-order-content__row--three">
          <InputSelectCustom
            v-model="employmentType"
            label="Занятость"
            :options="employmentTypeOptions"
            :leading-icon="''"
            :clearable="false"
            class="form-order-content__field"
          />
          <InputSelectCustom
            v-model="payRate"
            label="Тариф *"
            :options="payRateOptions"
            :leading-icon="''"
            :clearable="false"
            class="form-order-content__field"
          />
          <InputSelectCustom
            v-model="paymentTerms"
            label="Условия оплаты *"
            :options="paymentTermsOptions"
            :leading-icon="''"
            :clearable="false"
            class="form-order-content__field"
          />
        </div>

        <h3 class="form-order-content__title">Требования</h3>

        <div class="form-order-content__row form-order-content__row--two">
          <InputSelectCustom
            v-model="experienceLevel"
            label="Опыт"
            :options="experienceLevelOptions"
            :leading-icon="''"
            :clearable="false"
            class="form-order-content__field"
          />
          <InputSelectCustom
            v-model="keySkills"
            label="Ключевые навыки"
            :options="keySkillsOptions"
            :leading-icon="''"
            :clearable="false"
            class="form-order-content__field"
          />
        </div>

        <InputTextfieldCustom
          v-model="additionalRequirements"
          label=""
          placeholder="Добавить требования"
          class="form-order-content__field"
        />

        <div class="form-order-content__footer form-order-content__footer--with-back">
          <Button label="Назад" variant="outline" size="md" class="form-order-content__soft-btn" @click="$emit('prev')" />
          <div class="form-order-content__footer-actions">
            <Button label="Отменить" variant="outline" size="md" class="form-order-content__soft-btn" @click="$emit('cancel')" />
            <Button label="Далее" variant="fill" size="md" :disabled="!isRequirementsValid" @click="$emit('next')" />
          </div>
        </div>
      </template>

      <template v-else-if="section === 'sources'">
        <h3 class="form-order-content__title">Доступные Job-Сайты</h3>

        <IntegrationConnections ref="integrationConnectionsRef" />

        <div class="form-order-content__footer form-order-content__footer--with-back">
          <Button label="Назад" variant="outline" size="md" class="form-order-content__soft-btn" @click="$emit('prev')" />
          <div class="form-order-content__footer-actions">
            <Button label="Отменить" variant="outline" size="md" class="form-order-content__soft-btn" @click="$emit('cancel')" />
            <Button label="Далее" variant="fill" size="md" :disabled="!isSourcesValid" @click="$emit('next')" />
          </div>
        </div>
      </template>

      <template v-else-if="section === 'pipeline-template'">
        <h3 class="form-order-content__title">Шаблон воронки</h3>

        <div class="form-order-content__pipeline-list">
          <PipelineTemplateCard
            title="Основная воронка"
            subtitle="Администратор"
            description="Короткое описание или инструкция для чего используется основная воронка"
            :source-options="availableSources"
            v-model="primaryPipelineSources"
            v-model:enabled="primaryPipelineEnabled"
          />
          <PipelineTemplateCard
            title="Дополнительная воронка"
            subtitle="Администратор"
            description="Короткое описание или инструкция для чего используется дополнительная воронка"
            :source-options="availableSources"
            v-model="secondaryPipelineSources"
            v-model:enabled="secondaryPipelineEnabled"
          />
        </div>

        <div class="form-order-content__footer form-order-content__footer--with-back">
          <Button label="Назад" variant="outline" size="md" class="form-order-content__soft-btn" @click="$emit('prev')" />
          <div class="form-order-content__footer-actions">
            <Button label="Отменить" variant="outline" size="md" class="form-order-content__soft-btn" @click="$emit('cancel')" />
            <Button label="Далее" variant="fill" size="md" :disabled="!isPipelineTemplateValid" @click="$emit('next')" />
          </div>
        </div>
      </template>

      <template v-else>
        <h3 class="form-order-content__title">{{ sectionTitle }}</h3>
        <div class="form-order-content__placeholder">Раздел находится в разработке</div>
        <div class="form-order-content__footer form-order-content__footer--with-back">
          <Button label="Назад" variant="outline" size="md" class="form-order-content__soft-btn" @click="$emit('prev')" />
          <div class="form-order-content__footer-actions">
            <Button label="Отменить" variant="outline" size="md" class="form-order-content__soft-btn" @click="$emit('cancel')" />
            <Button label="Далее" variant="fill" size="md" @click="$emit('next')" />
          </div>
        </div>
      </template>
    </template>
  </section>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import Button from './Button.vue';
import IntegrationConnections from './IntegrationConnections.vue';
import InputPhoneCustom from './InputPhoneCustom.vue';
import InputTextfieldCustom from './InputTextfieldCustom.vue';
import InputSelectCustom from './InputSelectCustom.vue';
import PipelineTemplateCard from './PipelineTemplateCard.vue';
import Toggle from './Toggle.vue';
import avitoLogo from 'src/assets/logos/avito-logo.svg';
import hhLogo from 'src/assets/logos/hh-logo.svg';

defineOptions({ name: 'FormOrderContent' });

type FormSection = 'description' | 'requirements' | 'sources' | 'pipeline-template' | 'recruiters';

const props = withDefaults(
  defineProps<{
    title?: string;
    section?: FormSection;
  }>(),
  {
    title: '',
    section: 'description',
  },
);

const emit = defineEmits<{
  'update:title': [value: string];
  'update:sectionValid': [payload: { section: FormSection; valid: boolean }];
  next: [];
  prev: [];
  cancel: [];
}>();

const titleModel = computed({
  get: () => props.title,
  set: (value: string) => emit('update:title', value),
});

const isPrivate = ref(false);
const hideContacts = ref(false);
const city = ref<string | null>(null);
const address = ref<string | null>(null);
const closeDate = ref('');
const contactName = ref('');
const contactPhone = ref('');
const description = ref('');
const jobServiceType = ref<string | null>(null);
const positionsCount = ref<string | null>(null);
const workSchedule = ref<string | null>(null);
const employmentType = ref<string | null>(null);
const payRate = ref<string | null>(null);
const paymentTerms = ref<string | null>(null);
const experienceLevel = ref<string | null>(null);
const keySkills = ref<string | null>(null);
const additionalRequirements = ref('');
const primaryPipelineEnabled = ref(true);
const secondaryPipelineEnabled = ref(false);
const primaryPipelineSources = ref<Array<string | number>>([]);
const secondaryPipelineSources = ref<Array<string | number>>([]);
const integrationConnectionsRef = ref<InstanceType<typeof IntegrationConnections> | null>(null);
const savedEnabledSources = ref<Array<{ label: string; value: string }>>([]);

const showDateMenu = ref(false);
const closeDateAnchorRef = ref<HTMLElement | null>(null);
const closeDateMenuWidth = ref<number | null>(null);
const closeDateMenuTarget = computed<Element | undefined>(() => closeDateAnchorRef.value ?? undefined);
const closeDateMenuStyle = computed<Record<string, string>>(() =>
  closeDateMenuWidth.value ? { width: `${Math.round(closeDateMenuWidth.value)}px` } : {},
);
const sectionTitle = computed(() => {
  switch (props.section) {
    case 'requirements':
      return 'Условия и требования';
    case 'sources':
      return 'Источники';
    case 'pipeline-template':
      return 'Шаблон воронки';
    case 'recruiters':
      return 'Рекрутеры';
    default:
      return 'Описание заявки';
  }
});

const cityOptions = [
  { label: 'Краснодар', value: 'krasnodar' },
  { label: 'Воронеж', value: 'voronezh' },
];

const addressOptions = [
  { label: 'ул. Ленина, 10', value: 'lenina-10' },
  { label: 'ул. Мира, 22', value: 'mira-22' },
];

const jobServiceTypeOptions = [
  { label: 'Подбор персонала', value: 'staffing' },
  { label: 'Массовый подбор', value: 'mass-hiring' },
];
const positionsCountOptions = [
  { label: '1', value: '1' },
  { label: '2-5', value: '2-5' },
  { label: '6+', value: '6+' },
];
const workScheduleOptions = [
  { label: 'Полный день', value: 'full-time' },
  { label: 'Сменный', value: 'shift' },
  { label: 'Гибкий', value: 'flex' },
];
const employmentTypeOptions = [
  { label: 'Полная занятость', value: 'full' },
  { label: 'Частичная занятость', value: 'part' },
  { label: 'Проектная', value: 'project' },
];
const payRateOptions = [
  { label: 'Оклад', value: 'salary' },
  { label: 'Почасовая', value: 'hourly' },
  { label: 'Смешанная', value: 'mixed' },
];
const paymentTermsOptions = [
  { label: '2 раза в месяц', value: 'twice-monthly' },
  { label: '1 раз в месяц', value: 'monthly' },
  { label: 'Еженедельно', value: 'weekly' },
  { label: 'Ежедневная', value: 'daily' },
];
const experienceLevelOptions = [
  { label: 'Без опыта', value: 'none' },
  { label: '1-3 года', value: '1-3' },
  { label: '3+ года', value: '3+' },
];
const keySkillsOptions = [
  { label: 'Коммуникабельность', value: 'communication' },
  { label: 'Ответственность', value: 'responsibility' },
  { label: 'Профильные hard skills', value: 'hard-skills' },
];

function clearCloseDate(): void {
  closeDate.value = '';
}

function openDateMenu(): void {
  closeDateMenuWidth.value = closeDateAnchorRef.value?.getBoundingClientRect().width ?? null;
  showDateMenu.value = true;
}

const isFormValid = computed(() => {
  const hasTitle = titleModel.value.trim().length > 0;
  const hasCity = city.value !== null && city.value !== '';
  const hasAddress = address.value !== null && address.value !== '';
  const hasCloseDate = closeDate.value.trim().length > 0;

  return hasTitle && hasCity && hasAddress && hasCloseDate;
});
const isRequirementsValid = computed(() => {
  const hasPositionsCount = positionsCount.value !== null && positionsCount.value !== '';
  const hasPayRate = payRate.value !== null && payRate.value !== '';
  const hasPaymentTerms = paymentTerms.value !== null && paymentTerms.value !== '';

  return hasPositionsCount && hasPayRate && hasPaymentTerms;
});
const isPipelineTemplateValid = computed(() => primaryPipelineEnabled.value || secondaryPipelineEnabled.value);
const isSourcesValid = computed(() => integrationConnectionsRef.value?.isValid ?? false);
const availableSources = computed(() => {
  const sources = savedEnabledSources.value.length > 0 
    ? savedEnabledSources.value 
    : (integrationConnectionsRef.value as { enabledSources?: Array<{ label: string; value: string }> } | null)?.enabledSources ?? [];
  
  return sources.map((source: { label: string; value: string }) => {
    const sourceData: {
      label: string;
      value: string;
      logo?: string;
      status?: string;
    } = { ...source };
    
    if (source.value === 'avito') {
      sourceData.logo = avitoLogo;
      sourceData.status = 'Подключено';
    } else if (source.value === 'hh') {
      sourceData.logo = hhLogo;
      sourceData.status = 'Подключено';
    } else if (source.value === 'site-form') {
      sourceData.status = 'Подключено';
    } else if (source.value === 'vacancies') {
      sourceData.status = 'Подключено';
    }
    
    return sourceData;
  });
});

watch(
  [() => props.section, isFormValid, isRequirementsValid, isPipelineTemplateValid, isSourcesValid],
  ([section, descriptionValid, requirementsValid, pipelineTemplateValid, sourcesValid]) => {
    if (section === 'description') {
      emit('update:sectionValid', { section, valid: descriptionValid });
      return;
    }

    if (section === 'requirements') {
      emit('update:sectionValid', { section, valid: requirementsValid });
      return;
    }

    if (section === 'pipeline-template') {
      emit('update:sectionValid', { section, valid: pipelineTemplateValid });
      return;
    }

    if (section === 'sources') {
      emit('update:sectionValid', { section, valid: sourcesValid });
    }
  },
  { immediate: true },
);

watch(
  () => integrationConnectionsRef.value?.isValid,
  (isValid) => {
    if (props.section === 'sources' && isValid !== undefined) {
      emit('update:sectionValid', { section: 'sources', valid: isValid });
    }
  },
  { immediate: true },
);

watch(
  () => (integrationConnectionsRef.value as { enabledSources?: Array<{ label: string; value: string }> } | null)?.enabledSources,
  (enabledSources) => {
    if (enabledSources && enabledSources.length > 0) {
      savedEnabledSources.value = [...enabledSources];
    }
  },
  { immediate: true, deep: true },
);

function onNextClick(): void {
  if (!isFormValid.value) return;
  emit('next');
}

function isSelectableCloseDate(dateString: string): boolean {
  const [yearRaw, monthRaw, dayRaw] = dateString.split('/');
  const year = Number(yearRaw);
  const month = Number(monthRaw);
  const day = Number(dayRaw);
  if (!year || !month || !day) return false;

  const candidate = new Date(year, month - 1, day);
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  return candidate >= today;
}
</script>

<style scoped lang="scss">
.form-order-content {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 32px;
  background: var(--color-bg-white);
  box-sizing: border-box;
  min-height: 100%;
  height: 100%;
  overflow-y: auto;
  overflow-x: visible;
  position: relative;
}

.form-order-content__row {
  width: 100%;
  display: grid;
  gap: 24px;
  align-items: start;
}

.form-order-content__row--header {
  grid-template-columns: minmax(320px, 1fr) auto;
  gap: 16px;
}

.form-order-content__row--three {
  grid-template-columns: repeat(3, minmax(180px, 1fr));
}

.form-order-content__row--contacts {
  grid-template-columns: minmax(220px, 1fr) minmax(220px, 1fr) auto;
  align-items: center;
}

.form-order-content__row--two {
  grid-template-columns: repeat(2, minmax(220px, 1fr));
}

.form-order-content__field {
  width: 100%;
}

.form-order-content__title {
  margin: 0;
  padding: 16px 0 10px 0;
  font-family: var(--font-family-roboto);
  font-size: 18px;
  line-height: 20px;
  font-weight: 700;
  color: #000;
}

.form-order-content__title:first-of-type {
  padding-top: 0;
}


.form-order-content__textarea {
  width: 100%;
}

.form-order-content__textarea :deep(.input-textfield-custom__label) {
  display: none;
}

.form-order-content__textarea :deep(.input-textfield-custom__control) {
  border: 1px solid var(--input-border-color, #2f2b3d38);
  border-radius: 8px;
  padding: 14px 16px;
  min-height: 56px;
}

.form-order-content__textarea :deep(.input-textfield-custom__native--textarea) {
  min-height: 22px;
}

.form-order-content__date-icon {
  color: var(--color-primary-main);
  font-size: 20px;
}

:global(.form-order-content__date-menu) {
  border-radius: 10px;
  overflow: hidden;
}

:global(.form-order-content__date-menu .q-date) {
  width: 100%;
  border: 0;
  box-shadow: none;
}

.form-order-content__footer {
  margin-top: auto;
  width: 100%;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  position: sticky;
  bottom: 0;
  z-index: 2;
  padding-top: 8px;
  background: var(--color-bg-white);
}

.form-order-content__footer--with-back {
  justify-content: space-between;
  align-items: center;
}

.form-order-content__footer-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.form-order-content__placeholder {
  min-height: 160px;
  border: 1px dashed var(--color-secondary-main);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--color-text-secondary);
  font-family: var(--font-family-roboto);
  font-size: 14px;
}

.form-order-content__pipeline-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(280px, 1fr));
  gap: 16px;
  position: relative;
  z-index: 1;
}

@media (max-width: 1200px) {
  .form-order-content__row--header,
  .form-order-content__row--three,
  .form-order-content__row--contacts,
  .form-order-content__pipeline-list {
    grid-template-columns: 1fr;
  }
}
</style>
