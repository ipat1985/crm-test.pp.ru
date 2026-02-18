<template>
  <q-page class="tasks-page">
    <PageContainer>
      <PageHeader>
        <template #breadcrumb>
          <PageHeaderBreadcrumb
            :items="[
              { label: 'Главная', to: '/' },
              { label: 'Задания' },
            ]"
            separator=" - "
          />
        </template>
        <template #title>
          <PageHeaderTitle title="Задания" />
        </template>
        <template #actions>
          <PageHeaderActions
            primary-label="Добавить задание"
            primary-icon="o_add"
            @primary-click="onCreateTask"
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

      <PageContent page="task" state="empty" @action-click="onCreateTask" />
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
import PageContent from 'components/page/PageContent.vue';
import IconButton from 'components/IconButton.vue';

defineOptions({ name: 'TasksPage' });

const searchQuery = ref('');

function onCreateTask() {
  // TODO: открыть форму создания задания
}
</script>

<style scoped lang="scss">
.tasks-page {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
}
</style>
