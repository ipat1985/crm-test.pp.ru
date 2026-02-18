<template>
  <div
    class="table-item"
    :class="[
      `table-item--${type}`,
      `table-item--${textStyle}`,
      `table-item--${separator}`,
      `table-item--${align}`,
      {
        'table-item--dense': dense,
        'table-item--hover': state === 'hover',
        'table-item--rtl': rtl,
      },
    ]"
  >
    <template v-if="type === 'text'">
      <q-icon v-if="icon" :name="icon" class="table-item__icon" />
      <span class="table-item__label">{{ label }}</span>
    </template>

    <template v-else>
      <slot>
        <div class="table-item__slot">
          <div class="table-item__slot-icon">
            <q-icon name="o_compare_arrows" />
          </div>
        </div>
      </slot>
    </template>
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'TableItem' });

withDefaults(
  defineProps<{
    label?: string;
    icon?: string;
    type?: 'text' | 'swap';
    textStyle?: 'cell' | 'header';
    separator?: 'default' | 'vertical' | 'cell' | 'none';
    align?: 'center' | 'left' | 'right';
    state?: 'default' | 'hover';
    dense?: boolean;
    rtl?: boolean;
  }>(),
  {
    label: 'Label',
    icon: '',
    type: 'text',
    textStyle: 'cell',
    separator: 'default',
    align: 'center',
    state: 'default',
    dense: false,
    rtl: false,
  },
);
</script>

<style scoped lang="scss">
.table-item {
  display: flex;
  align-items: center;
  gap: var(--table-item-gap);
  height: var(--table-item-height);
  padding: 0 var(--table-item-padding-x);
  box-sizing: border-box;
  color: var(--table-item-text-color);
  user-select: none;

  &--dense {
    height: var(--table-item-height-dense);
  }

  &--center {
    justify-content: center;
    text-align: center;
  }

  &--left {
    justify-content: flex-start;
    text-align: left;
  }

  &--right {
    justify-content: flex-end;
    text-align: right;
  }

  &--rtl {
    direction: rtl;
  }

  &--default {
    border-bottom: 1px solid var(--table-item-border-color);
  }

  &--vertical {
    border-bottom: 1px solid var(--table-item-border-color);
    border-right: 1px solid var(--table-item-border-color);
  }

  &--cell {
    border: 1px solid var(--table-item-border-color);
  }

  &--none {
    border: none;
  }

  &--hover {
    background: var(--table-item-hover-bg);
  }
}

.table-item__label {
  font-family: var(--font-family-primary);
  line-height: 1;
}

.table-item--cell .table-item__label {
  font-size: var(--table-item-font-size-cell);
  font-weight: var(--table-item-font-weight-cell);
}

.table-item--header .table-item__label {
  font-size: var(--table-item-font-size-header);
  font-weight: var(--table-item-font-weight-header);
}

.table-item__icon {
  font-size: 18px;
}

.table-item__slot {
  width: min(100%, var(--table-item-slot-width));
  height: var(--table-item-slot-height);
  background: var(--table-item-slot-bg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.table-item__slot-icon {
  width: 40px;
  height: 40px;
  background: var(--table-item-slot-icon-bg);
  border: 1px solid var(--table-item-slot-icon-border);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
