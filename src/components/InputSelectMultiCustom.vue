<template>
  <div
    ref="anchorRef"
    class="input-select-multi-custom"
    :class="[
      { 'input-select-multi-custom--opened': opened },
      { 'input-select-multi-custom--floating': isFloating },
    ]"
  >
    <div
      class="input-select-multi-custom__control"
      tabindex="0"
      role="button"
      @click.stop="toggleMenu"
      @keydown.enter.prevent="toggleMenu"
      @keydown.space.prevent="toggleMenu"
      @focus="onFocus"
      @blur="onBlur"
    >
      <div class="input-select-multi-custom__content">
        <span v-if="label && isFloating" class="input-select-multi-custom__label">{{ label }}</span>
        <div v-if="isFloating" class="input-select-multi-custom__chips">
          <span v-if="selectedValues.length === 0" class="input-select-multi-custom__placeholder">{{ placeholder }}</span>
          <template v-else>
            <span
              v-for="value in displayChips"
              :key="String(value)"
              class="input-select-multi-custom__chip"
            >
              {{ getOptionLabel(value) }}
            </span>
            <span v-if="selectedValues.length > maxChips" class="input-select-multi-custom__chip-more">
              +{{ selectedValues.length - maxChips }}
            </span>
          </template>
        </div>
        <span v-if="!isFloating && selectedValues.length === 0 && placeholder" class="input-select-multi-custom__placeholder">{{ placeholder }}</span>
      </div>

      <q-icon
        v-if="clearable && selectedValues.length > 0 && !disabled && !readonly"
        name="o_close"
        class="input-select-multi-custom__icon input-select-multi-custom__clear"
        @click.stop="clearValue"
      />
      <q-icon
        name="o_expand_more"
        class="input-select-multi-custom__icon input-select-multi-custom__arrow"
        :class="{ 'input-select-multi-custom__arrow--opened': opened }"
      />
    </div>

    <q-menu
      v-model="opened"
      :target="menuTarget"
      anchor="bottom left"
      self="top left"
      :offset="[0, 8]"
      fit
      no-parent-event
      class="input-select-multi-custom__menu"
    >
      <div class="input-select-multi-custom__menu-list">
        <label
          v-for="option in normalizedOptions"
          :key="String(option.value)"
          class="input-select-multi-custom__option"
          :class="{ 'input-select-multi-custom__option--active': isSelected(option.value) }"
        >
          <Checkbox
            :model-value="isSelected(option.value)"
            :label="option.label"
            size="sm"
            dense
            @update:model-value="(checked: boolean) => toggleOption(option.value, checked)"
          />
        </label>
      </div>
    </q-menu>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import Checkbox from './Checkbox.vue';

defineOptions({ name: 'InputSelectMultiCustom' });

type SelectOptionValue = string | number;
type RawOption = Record<string, unknown>;
interface NormalizedOption {
  label: string;
  value: SelectOptionValue;
}

const props = withDefaults(
  defineProps<{
    modelValue?: SelectOptionValue[];
    options: RawOption[];
    label?: string;
    placeholder?: string;
    clearable?: boolean;
    disabled?: boolean;
    readonly?: boolean;
    maxChips?: number;
  }>(),
  {
    modelValue: () => [],
    options: () => [],
    label: '',
    placeholder: 'Выберите источники',
    clearable: true,
    disabled: false,
    readonly: false,
    maxChips: 2,
  },
);

const emit = defineEmits<{
  'update:modelValue': [value: SelectOptionValue[]];
}>();

const anchorRef = ref<HTMLElement | null>(null);
const opened = ref(false);
const focused = ref(false);
const menuTarget = computed<Element | undefined>(() => anchorRef.value ?? undefined);

const normalizedOptions = computed<NormalizedOption[]>(() => {
  return props.options.map((opt) => {
    const labelValue = opt.label ?? opt.value ?? '';
    const labelStr = typeof labelValue === 'string' || typeof labelValue === 'number' 
      ? String(labelValue) 
      : '';
    return {
      label: labelStr,
      value: opt.value as SelectOptionValue,
    };
  });
});

const selectedValues = computed(() => props.modelValue ?? []);

const isFloating = computed(() => selectedValues.value.length > 0 || focused.value || opened.value);

const displayChips = computed(() => {
  return selectedValues.value.slice(0, props.maxChips);
});

function getOptionLabel(value: SelectOptionValue): string {
  const option = normalizedOptions.value.find((opt) => opt.value === value);
  return option?.label ?? String(value);
}

function isSelected(value: SelectOptionValue): boolean {
  return selectedValues.value.includes(value);
}

function toggleOption(value: SelectOptionValue, checked?: boolean): void {
  const current = [...selectedValues.value];
  const index = current.indexOf(value);
  const shouldSelect = checked !== undefined ? checked : !isSelected(value);
  
  if (shouldSelect && index === -1) {
    current.push(value);
  } else if (!shouldSelect && index > -1) {
    current.splice(index, 1);
  }
  emit('update:modelValue', current);
}

function clearValue(): void {
  emit('update:modelValue', []);
}

function toggleMenu(event?: Event): void {
  if (props.disabled || props.readonly) return;
  if (event) {
    event.stopPropagation();
    event.preventDefault();
  }
  opened.value = !opened.value;
}

function onFocus(): void {
  focused.value = true;
}

function onBlur(): void {
  focused.value = false;
}
</script>

<style scoped lang="scss">
.input-select-multi-custom {
  position: relative;
  width: 100%;
}

.input-select-multi-custom__control {
  min-height: 40px;
  padding: 8px 12px;
  border: 1px solid var(--input-border-color, #e0e0e0);
  border-radius: 8px;
  background: var(--color-bg-white);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  cursor: pointer;
  box-sizing: border-box;
  transition: border-color 0.2s;

  &:hover:not(:disabled) {
    border-color: var(--color-primary-main);
  }

  &:focus-within {
    border-color: var(--color-primary-main);
    outline: none;
  }
}

.input-select-multi-custom--floating .input-select-multi-custom__control {
  padding-top: 20px;
  padding-bottom: 8px;
}

.input-select-multi-custom__content {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.input-select-multi-custom__label {
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
  color: var(--color-text-secondary);
  transition: all 0.2s;
}

.input-select-multi-custom--floating .input-select-multi-custom__label {
  font-size: 12px;
  line-height: 16px;
  color: var(--color-primary-main);
}

.input-select-multi-custom__chips {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  align-items: center;
}

.input-select-multi-custom__placeholder {
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
  color: var(--color-text-secondary);
  opacity: 0.6;
}

.input-select-multi-custom__chip {
  display: inline-flex;
  align-items: center;
  padding: 4px 8px;
  background: var(--color-primary-opacity-light);
  border-radius: 4px;
  font-family: var(--font-family-roboto);
  font-size: 12px;
  line-height: 16px;
  color: var(--color-primary-main);
}

.input-select-multi-custom__chip-more {
  display: inline-flex;
  align-items: center;
  padding: 4px 8px;
  background: var(--color-primary-opacity-light);
  border-radius: 4px;
  font-family: var(--font-family-roboto);
  font-size: 12px;
  line-height: 16px;
  color: var(--color-primary-main);
}

.input-select-multi-custom__icon {
  flex-shrink: 0;
  font-size: 20px;
  color: var(--color-text-secondary);
  transition: transform 0.2s;
}

.input-select-multi-custom__clear {
  color: var(--color-primary-main);
  cursor: pointer;

  &:hover {
    opacity: 0.7;
  }
}

.input-select-multi-custom__arrow {
  color: var(--color-text-secondary);
}

.input-select-multi-custom__arrow--opened {
  transform: rotate(180deg);
}

.input-select-multi-custom__menu {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  z-index: 7000 !important;
}

:global(.input-select-multi-custom__menu .q-menu) {
  z-index: 7000 !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.input-select-multi-custom__menu-list {
  padding: 8px;
  background: var(--color-bg-white);
  min-width: 200px;
  max-height: 300px;
  overflow-y: auto;
}

.input-select-multi-custom__option {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  border-radius: 4px;
  cursor: pointer;
  user-select: none;
  transition: background-color 0.2s;

  &:hover {
    background: var(--color-primary-opacity-lighter);
  }

  &--active {
    background: var(--color-primary-opacity-light);
  }
}

</style>
