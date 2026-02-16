<template>
  <div class="header-left-area">
    <IconButton
      icon="o_history"
      variant="icon"
      :aria-label="notificationsLabel"
      @click="$emit('notifications-click', $event)"
    />
    <Button
      label="Пополнить баланс"
      icon="o_add"
      variant="outline"
      rounded
      class="header-left-area__recharge"
      @click="$emit('recharge-click', $event)"
    />
    <div class="header-left-area__balance">
      <div class="header-left-area__balance-row">
        <span class="header-left-area__balance-label">{{ paymentLabel }}:</span>
        <span class="header-left-area__balance-value">{{ formatAmount(paymentBalance) }}</span>
      </div>
      <div class="header-left-area__balance-row">
        <span class="header-left-area__balance-label">{{ commissionLabel }}:</span>
        <span class="header-left-area__balance-value">{{ formatAmount(commissionBalance) }}</span>
      </div>
    </div>
    <IconButton
      icon="o_history"
      variant="outlined"
      shape="circle"
      :aria-label="notificationsLabel"
      @click="$emit('notifications-click', $event)"
    />
  </div>
</template>

<script setup lang="ts">
import Button from 'components/Button.vue';
import IconButton from 'components/IconButton.vue';

withDefaults(
  defineProps<{
    paymentBalance?: number;
    commissionBalance?: number;
    paymentLabel?: string;
    commissionLabel?: string;
    notificationsLabel?: string;
  }>(),
  {
    paymentBalance: 95000,
    commissionBalance: 5000,
    paymentLabel: 'Баланс для оплаты',
    commissionLabel: 'Баланс комиссии',
    notificationsLabel: 'Уведомления',
  },
);

defineEmits<{
  'notifications-click': [event: Event];
  'recharge-click': [event: Event];
}>();

function formatAmount(value: number): string {
  return new Intl.NumberFormat('ru-RU', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(value) + ' ₽';
}
</script>

<style scoped lang="scss">
.header-left-area {
  display: flex;
  align-items: center;
  gap: var(--header-left-gap);
}

.header-left-area__recharge {
  background: var(--header-left-recharge-bg);
}

.header-left-area__balance {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.header-left-area__balance-row {
  font-size: var(--header-left-balance-font-size);
  line-height: var(--header-left-balance-line-height);

  .header-left-area__balance-label {
    color: var(--header-left-balance-label-color);
    margin-right: 4px;
  }

  .header-left-area__balance-value {
    color: var(--header-left-balance-value-color);
    font-weight: 500;
  }
}
</style>
