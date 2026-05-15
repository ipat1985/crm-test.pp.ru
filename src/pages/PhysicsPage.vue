<template>
  <q-page class="physics-page">
    <PageContainer>
      <PageHeader>
        <template #breadcrumb>
          <PageHeaderBreadcrumb
            :items="[
              { label: 'Главная', to: '/' },
              { label: 'Физики' },
            ]"
            separator=" - "
          />
        </template>
        <template #title>
          <PageHeaderTitle title="Физики" />
        </template>
      </PageHeader>

      <PageContent page="physics" state="empty" />
    </PageContainer>
  </q-page>
</template>

<script setup lang="ts">
import PageContainer from 'components/layout/PageContainer.vue';
import PageHeader from 'components/page/PageHeader.vue';
import PageHeaderBreadcrumb from 'components/page/PageHeaderBreadcrumb.vue';
import PageHeaderTitle from 'components/page/PageHeaderTitle.vue';
import PageContent from 'components/page/PageContent.vue';

defineOptions({ name: 'PhysicsPage' });
</script>

<style scoped lang="scss">
.physics-page {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
}
</style>
