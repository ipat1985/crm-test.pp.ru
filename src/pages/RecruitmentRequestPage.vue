<template>
  <q-page class="recruitment-request-page">
    <PageContainer>
      <PageHeader>
        <template #breadcrumb>
          <PageHeaderBreadcrumb
            :items="[
              { label: 'Главная', to: '/' },
              { label: 'Рекрутинг' },
              { label: 'Заявка на подбор' },
            ]"
            separator=" - "
          />
        </template>
        <template #title>
          <PageHeaderTitle title="Заявка на подбор" />
        </template>
        <template #actions>
          <PageHeaderActions
            primary-label="Добавить заявку"
            primary-icon="o_add"
            @primary-click="onCreateRequest"
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

      <PageContent
        page="recruitment-request"
        state="empty"
        @action-click="onCreateRequest"
      />
    </PageContainer>
  </q-page>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import PageContainer from 'components/layout/PageContainer.vue';
import PageHeader from 'components/page/PageHeader.vue';
import PageHeaderActions from 'components/page/PageHeaderActions.vue';
import PageHeaderBreadcrumb from 'components/page/PageHeaderBreadcrumb.vue';
import PageHeaderSearch from 'components/page/PageHeaderSearch.vue';
import PageHeaderTitle from 'components/page/PageHeaderTitle.vue';
import PageContent from 'components/page/PageContent.vue';
import IconButton from 'components/IconButton.vue';

defineOptions({ name: 'RecruitmentRequestPage' });

const router = useRouter();
const searchQuery = ref('');

function onCreateRequest() {
  void router.push('/recruitment/request/create');
}
</script>

<style scoped lang="scss">
.recruitment-request-page {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
}
</style>
