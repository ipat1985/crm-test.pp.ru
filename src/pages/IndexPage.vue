<template>
  <q-page class="index-page">
    <PageContainer>
      <PageHeader>
        <template #breadcrumb>
          <PageHeaderBreadcrumb :items="[{ label: 'Главная' }]" />
        </template>
        <template #title>
          <PageHeaderTitle title="Главная" />
        </template>
      </PageHeader>

      <IndexPageContent>
        <IndexStartContent @action-click="onAddElement" />
      </IndexPageContent>
    </PageContainer>
  </q-page>
</template>

<script setup lang="ts">
import PageContainer from 'components/layout/PageContainer.vue';
import PageHeader from 'components/page/PageHeader.vue';
import PageHeaderBreadcrumb from 'components/page/PageHeaderBreadcrumb.vue';
import PageHeaderTitle from 'components/page/PageHeaderTitle.vue';
import IndexPageContent from 'components/page/index/IndexPageContent.vue';
import IndexStartContent from 'components/page/index/IndexStartContent.vue';

defineOptions({ name: 'IndexPage' });

function onAddElement() {
  // TODO: открыть форму добавления элемента
}
</script>

<style scoped lang="scss">
.index-page {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
}
</style>
