<template>
  <button
    type="button"
    class="form-menu-item"
    :class="[
      `form-menu-item--${stateClass}`,
      { 'form-menu-item--clickable': clickable && !disabled },
    ]"
    :disabled="disabled"
    @click="$emit('click', $event)"
  >
    <q-icon v-if="leftIcon" :name="leftIconName" class="form-menu-item__icon" />
    <span class="form-menu-item__label">{{ label }}</span>
    <q-icon v-if="rightIcon" :name="rightIconName" class="form-menu-item__icon" />
  </button>
</template>

<script setup lang="ts">
import { computed } from 'vue';

defineOptions({ name: 'FormMenuItem' });

const props = withDefaults(
  defineProps<{
    label?: string;
    state?: 'default' | 'hover' | 'focused' | 'disable' | 'active-done' | 'unactive-done';
    leftIcon?: boolean;
    rightIcon?: boolean;
    leftIconName?: string;
    rightIconName?: string;
    disabled?: boolean;
    clickable?: boolean;
  }>(),
  {
    label: 'Условия и требования',
    state: 'default',
    leftIcon: true,
    rightIcon: true,
    leftIconName: 'cached',
    rightIconName: 'cached',
    disabled: false,
    clickable: true,
  },
);

defineEmits<{
  click: [event: Event];
}>();

const stateClass = computed(() => props.state);
</script>

<style scoped lang="scss">
.form-menu-item {
  width: 100%;
  height: 44px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 4px 16px;
  border: 0;
  border-radius: 3px;
  background: transparent;
  color: var(--color-primary-main);
  opacity: 1;
  box-sizing: border-box;
  transition: background-color 0.2s ease, opacity 0.2s ease, color 0.2s ease;
}

.form-menu-item--clickable {
  cursor: pointer;
}

.form-menu-item__icon {
  font-size: 24px;
  color: inherit;
}

.form-menu-item__label {
  font-family: var(--font-family-fa);
  color: inherit;
  font-size: 14px;
  font-weight: 400;
  line-height: 20px;
  white-space: nowrap;
}

.form-menu-item--default {
  background: transparent;
}

.form-menu-item--hover {
  background: var(--color-primary-o-light);
}

.form-menu-item--focused {
  background: var(--color-bg-surface);
}

.form-menu-item--focused .form-menu-item__label {
  font-size: 14px;
  font-weight: 500;
  line-height: 22px;
}

.form-menu-item--active-done {
  background: var(--color-bg-surface);
}

.form-menu-item--active-done .form-menu-item__label {
  font-size: 14px;
  font-weight: 500;
  line-height: 22px;
}

.form-menu-item--unactive-done {
  opacity: 0.7;
  background: transparent;
}

.form-menu-item--disable {
  opacity: 0.7;
  cursor: default;
}
</style>
