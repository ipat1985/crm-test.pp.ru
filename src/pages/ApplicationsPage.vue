<template>
  <q-page class="applications-page">
    <PageContainer>
      <PageHeader>
        <template #breadcrumb>
          <PageHeaderBreadcrumb
            :items="[
              { label: 'Главная', to: '/' },
              { label: 'Заявки на подбор' },
            ]"
            separator=" - "
          />
        </template>
        <template #title>
          <PageHeaderTitle title="Заявки на подбор" />
        </template>
        <template #actions>
          <PageHeaderActions
            primary-label="Добавить заявку"
            primary-icon="o_add"
            @primary-click="onCreateApplication"
          >
            <template #search>
              <PageHeaderSearch
                v-model="searchQuery"
                placeholder="Введите адрес, название или ИНН клиента для поиска"
              />
            </template>
            <template #leading>
              <IconButton
                icon="o_file_upload"
                variant="outlined"
                shape="square"
                aria-label="Загрузить"
              />
            </template>
          </PageHeaderActions>
        </template>
      </PageHeader>

      <OrderPageContent>
        <OrderEmptyState @action-click="onCreateApplication" />
      </OrderPageContent>
    </PageContainer>
  </q-page>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import PageContainer from 'components/layout/PageContainer.vue';
import PageHeader from 'components/page/PageHeader.vue';
import PageHeaderActions from 'components/page/PageHeaderActions.vue';
import PageHeaderBreadcrumb from 'components/page/PageHeaderBreadcrumb.vue';
import PageHeaderSearch from 'components/page/PageHeaderSearch.vue';
import PageHeaderTitle from 'components/page/PageHeaderTitle.vue';
import OrderPageContent from 'components/page/order/OrderPageContent.vue';
import OrderEmptyState from 'components/page/order/OrderEmptyState.vue';
import IconButton from 'components/IconButton.vue';

defineOptions({ name: 'ApplicationsPage' });

const searchQuery = ref('');

function onCreateApplication() {
  // TODO: открыть форму создания заявки
}
</script>

<style scoped lang="scss">
.applications-page {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
}
</style>
