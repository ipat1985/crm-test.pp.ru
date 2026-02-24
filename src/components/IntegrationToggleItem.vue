<template>
  <div class="integration-toggle-item" :class="{ 'integration-toggle-item--disabled': disabled }">
    <div class="integration-toggle-item__row">
      <div class="integration-toggle-item__left">
        <img :src="logoSrc" :alt="siteName" class="integration-toggle-item__logo" />

        <div class="integration-toggle-item__text">
          <div class="integration-toggle-item__title">{{ siteName }}</div>
          <div class="integration-toggle-item__subtitle" :class="{ 'integration-toggle-item__subtitle--connected': modelValue }">
            {{ statusText }}
          </div>
        </div>

        <button
          type="button"
          class="integration-toggle-item__switch"
          :class="{ 'integration-toggle-item__switch--on': modelValue }"
          :disabled="disabled"
          @click="$emit('update:modelValue', !modelValue)"
        >
          <span class="integration-toggle-item__thumb" />
        </button>
      </div>

      <div class="integration-toggle-item__select-wrap" :class="{ 'integration-toggle-item__select-wrap--hidden': !modelValue }">
        <div
          ref="selectAnchorRef"
          class="integration-toggle-item__select"
          :class="{ 'integration-toggle-item__select--open': menuOpen }"
          @click="openMenu"
        >
          <template v-if="selectedOptions.length">
            <div class="integration-toggle-item__selected-content">
              <span class="integration-toggle-item__selected-label">
                Отклик кандидатов из объявлений со следующими хештегами:
              </span>
              <div class="integration-toggle-item__chips">
                <span v-for="option in selectedOptions" :key="String(option.value)" class="integration-toggle-item__chip">
                  <span>{{ option.label }}</span>
                  <q-icon name="o_close" class="integration-toggle-item__chip-close" @click.stop="removeOption(option.value)" />
                </span>
              </div>
            </div>
          </template>
          <template v-else>
            <span class="integration-toggle-item__placeholder">Хештег</span>
          </template>
          <q-icon name="o_expand_more" class="integration-toggle-item__arrow" :class="{ 'integration-toggle-item__arrow--open': menuOpen }" />
        </div>

        <q-menu
          v-model="menuOpen"
          :target="menuTarget"
          anchor="bottom left"
          self="top left"
          :offset="[0, 8]"
          no-parent-event
          :style="menuStyle"
          class="integration-toggle-item__menu"
        >
          <div class="integration-toggle-item__menu-list">
            <div class="integration-toggle-item__search-wrap">
              <q-icon name="o_search" class="integration-toggle-item__search-icon" />
              <input
                v-model="searchQuery"
                type="text"
                class="integration-toggle-item__search-input"
                placeholder="Поиск хештега"
                @click.stop
              />
            </div>

            <label
              v-for="option in filteredOptions"
              :key="String(option.value)"
              class="integration-toggle-item__menu-item"
              :class="{ 'integration-toggle-item__menu-item--selected': hasOption(option.value) }"
            >
              <input
                type="checkbox"
                class="integration-toggle-item__checkbox"
                :checked="hasOption(option.value)"
                @change="toggleOption(option.value)"
              />
              <span>{{ option.label }}</span>
            </label>
          </div>
        </q-menu>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';

defineOptions({ name: 'IntegrationToggleItem' });

type SelectValue = string | number;
interface SelectOption {
  [key: string]: unknown;
  label: string;
  value: SelectValue;
}

const props = withDefaults(
  defineProps<{
    modelValue?: boolean;
    stages?: SelectValue[];
    stageOptions?: SelectOption[];
    disabled?: boolean;
    siteName: string;
    logoSrc: string;
  }>(),
  {
    modelValue: false,
    stages: () => [],
    stageOptions: () => [{ label: 'Label', value: 'label' }],
    disabled: false,
  },
);

const emit = defineEmits<{
  'update:modelValue': [value: boolean];
  'update:stages': [value: SelectValue[]];
}>();

const menuOpen = ref(false);
const selectAnchorRef = ref<HTMLElement | null>(null);
const menuTarget = computed<Element | undefined>(() => selectAnchorRef.value ?? undefined);
const menuWidth = ref<number>(396);
const searchQuery = ref('');

const selectedOptions = computed(() => props.stageOptions.filter((option) => props.stages.includes(option.value)));
const filteredOptions = computed(() => {
  const query = searchQuery.value.trim().toLowerCase();
  if (!query) return props.stageOptions;
  return props.stageOptions.filter((option) => option.label.toLowerCase().includes(query));
});
const menuStyle = computed<Record<string, string>>(() => ({
  width: `${Math.round(menuWidth.value)}px`,
}));

const statusText = computed(() => {
  if (props.disabled) return 'Интеграция не подключена';
  if (props.modelValue) return 'Подключено';
  return 'Отключено';
});

function openMenu(): void {
  if (!props.modelValue || props.disabled) return;
  menuWidth.value = selectAnchorRef.value?.getBoundingClientRect().width ?? 396;
  menuOpen.value = true;
}

function hasOption(value: SelectValue): boolean {
  return props.stages.includes(value);
}

function toggleOption(value: SelectValue): void {
  if (hasOption(value)) {
    emit(
      'update:stages',
      props.stages.filter((item) => item !== value),
    );
    return;
  }

  emit('update:stages', [...props.stages, value]);
}

function removeOption(value: SelectValue): void {
  emit(
    'update:stages',
    props.stages.filter((item) => item !== value),
  );
}
</script>

<style scoped lang="scss">
.integration-toggle-item {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.integration-toggle-item--disabled {
  opacity: 0.7;
}

.integration-toggle-item__row {
  display: flex;
  align-items: center;
  gap: 64px;
}

.integration-toggle-item__left {
  width: 300px;
  display: flex;
  align-items: center;
  gap: 16px;
  flex: 0 0 auto;
}

.integration-toggle-item__logo {
  width: 44px;
  height: 44px;
  flex: 0 0 auto;
}

.integration-toggle-item__text {
  min-width: 0;
  margin-right: auto;
}

.integration-toggle-item__title {
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
  color: var(--color-text-primary);
}

.integration-toggle-item__subtitle {
  font-family: var(--font-family-roboto);
  font-size: 12px;
  line-height: 16px;
  color: var(--color-text-secondary);
}

.integration-toggle-item__subtitle--connected {
  color: var(--color-primary-main);
}

.integration-toggle-item__switch {
  width: 32px;
  height: 14px;
  border: 0;
  border-radius: 99px;
  padding: 0;
  background: rgba(46, 38, 61, 0.24);
  position: relative;
  cursor: pointer;
}

.integration-toggle-item__switch--on {
  background: rgba(115, 103, 240, 0.24);
}

.integration-toggle-item__thumb {
  width: 20px;
  height: 20px;
  border-radius: 99px;
  background: #fff;
  box-shadow:
    0 1px 5px 0 rgba(0, 0, 0, 0.2),
    0 2px 2px 0 rgba(0, 0, 0, 0.14),
    0 3px 1px -2px rgba(0, 0, 0, 0.12);
  position: absolute;
  top: 50%;
  left: 0;
  transform: translateY(-50%);
  transition: left 0.2s ease, background-color 0.2s ease;
}

.integration-toggle-item__switch--on .integration-toggle-item__thumb {
  left: 12px;
  background: var(--color-primary-main);
}

.integration-toggle-item__switch:disabled {
  cursor: not-allowed;
}

.integration-toggle-item__extra {
  width: 100%;
  max-width: 396px;
}

.integration-toggle-item__select-wrap {
  flex: 1 1 auto;
  width: auto;
  min-height: 56px;
  margin-left: 0;
}

.integration-toggle-item__select-wrap--hidden {
  opacity: 0;
  visibility: hidden;
  pointer-events: none;
}

.integration-toggle-item__select {
  min-height: 56px;
  border: 1px solid var(--input-border-color, #2f2b3d38);
  border-radius: 8px;
  background: var(--color-bg-white);
  box-sizing: border-box;
  padding: 6px 12px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  cursor: pointer;
}

.integration-toggle-item__chips {
  min-width: 0;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  flex-wrap: wrap;
}

.integration-toggle-item__selected-content {
  min-width: 0;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 4px;
}

.integration-toggle-item__selected-label {
  font-family: var(--font-family-roboto);
  font-size: 12px;
  line-height: 16px;
  color: var(--color-text-secondary);
}

.integration-toggle-item__select--open {
  border-color: var(--color-primary-main);
}

.integration-toggle-item__placeholder {
  color: var(--color-text-secondary);
  font-family: var(--font-family-roboto);
  font-size: 16px;
  line-height: 20px;
}

.integration-toggle-item__arrow {
  color: var(--color-text-secondary);
  font-size: 20px;
  transition: transform 0.2s ease;
}

.integration-toggle-item__arrow--open {
  transform: rotate(180deg);
}

.integration-toggle-item__chip {
  height: 24px;
  border-radius: 4px;
  background: var(--color-primary-main);
  color: var(--color-bg-white);
  padding: 0 6px;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
}

.integration-toggle-item__chip-close {
  font-size: 16px;
  cursor: pointer;
}

.integration-toggle-item__menu-list {
  width: 100%;
  max-height: 240px;
  overflow: auto;
  background: var(--color-bg-white);
  border-radius: 10px;
}

.integration-toggle-item__menu {
  border-radius: 10px;
  overflow: hidden;
  box-shadow:
    0 8px 24px rgba(0, 0, 0, 0.08),
    0 2px 6px rgba(0, 0, 0, 0.06);
}

.integration-toggle-item__search-wrap {
  position: sticky;
  top: 0;
  z-index: 1;
  background: #f4f5fa;
  border-bottom: 1px solid rgba(47, 43, 61, 0.12);
  padding: 8px 14px;
  display: flex;
  align-items: center;
  gap: 10px;
  min-height: 48px;
}

.integration-toggle-item__search-icon {
  color: #6d6b77;
  font-size: 20px;
}

.integration-toggle-item__search-input {
  width: 100%;
  border: 0;
  outline: 0;
  background: transparent;
  font-family: var(--font-family-fa);
  font-size: 14px;
  line-height: 20px;
  color: var(--color-text-primary);
}

.integration-toggle-item__search-input::placeholder {
  color: #7e7b8f;
  opacity: 1;
}

.integration-toggle-item__menu-item {
  width: 100%;
  box-sizing: border-box;
  padding: 10px 12px;
  display: flex;
  align-items: center;
  gap: 10px;
  color: var(--color-text-primary);
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
  cursor: pointer;
}

.integration-toggle-item__menu-item:hover {
  background: var(--color-primary-o-light);
}

.integration-toggle-item__menu-item--selected {
  color: var(--color-primary-main);
}

.integration-toggle-item__checkbox {
  width: 16px;
  height: 16px;
  margin: 0;
  accent-color: var(--color-primary-main);
}
</style>
