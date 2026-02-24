<template>
  <q-page class="recruitment-request-create-page">
    <PageContainer>
      <PageHeader>
        <template #breadcrumb>
          <PageHeaderBreadcrumb
            :items="[
              { label: 'Главная', to: '/' },
              { label: 'Рекрутинг', to: '/recruitment/request' },
              { label: 'Новая заявка на подбор' },
            ]"
            separator=" - "
          />
        </template>
        <template #title>
          <PageHeaderTitle :title="pageTitle" />
        </template>
        <template #actions>
          <PageHeaderActions>
            <Button
              label="Сохранить черновик"
              variant="outline"
              size="md"
              @click="onSaveDraft"
            />
            <Button
              label="Опубликовать"
              variant="fill"
              size="md"
              :disabled="true"
              @click="onPublish"
            />
          </PageHeaderActions>
        </template>
      </PageHeader>
      <section class="recruitment-request-create-page__content">
        <Form v-model:title="requestTitle" @cancel="showCancelDialog = true" />
      </section>
    </PageContainer>

    <q-dialog v-model="showCancelDialog" class="recruitment-request-create-page__cancel-dialog-wrap">
      <q-card class="recruitment-request-create-page__cancel-dialog">
        <q-card-section class="recruitment-request-create-page__cancel-header">
          <span>Внимание!</span>
          <q-btn
            flat
            dense
            icon="o_close"
            class="recruitment-request-create-page__cancel-close"
            @click="showCancelDialog = false"
          />
        </q-card-section>

        <q-card-section class="recruitment-request-create-page__cancel-text">
          Похоже, вы не закончили заполнение формы.
          Хотите сохранить введённые данные перед уходом и продолжить позже?
        </q-card-section>

        <q-card-actions align="right" class="recruitment-request-create-page__cancel-actions">
          <Button label="Не сохранять" variant="outline" size="md" @click="onCloseWithoutSaving" />
          <Button label="Сохранить в черновик" variant="fill" size="md" @click="onCloseWithDraft" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import { useRouter } from 'vue-router';
import PageContainer from 'components/layout/PageContainer.vue';
import PageHeader from 'components/page/PageHeader.vue';
import PageHeaderActions from 'components/page/PageHeaderActions.vue';
import PageHeaderBreadcrumb from 'components/page/PageHeaderBreadcrumb.vue';
import PageHeaderTitle from 'components/page/PageHeaderTitle.vue';
import Button from 'components/Button.vue';
import Form from 'components/Form.vue';

defineOptions({ name: 'RecruitmentRequestCreatePage' });

const router = useRouter();
const requestTitle = ref('');
const showCancelDialog = ref(false);
const pageTitle = computed(() => requestTitle.value.trim() || 'Новая заявка на подбор');

function onSaveDraft(): void {
  // TODO: сохранить в черновик
}

function onPublish(): void {
  // TODO: опубликовать заявку
}

function closeCreateProcess(): void {
  void router.push('/recruitment/request');
}

function onCloseWithDraft(): void {
  onSaveDraft();
  showCancelDialog.value = false;
  closeCreateProcess();
}

function onCloseWithoutSaving(): void {
  showCancelDialog.value = false;
  closeCreateProcess();
}
</script>

<style scoped lang="scss">
.recruitment-request-create-page {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
}

.recruitment-request-create-page__content {
  width: 100%;
  flex: 1 1 auto;
  min-height: 0;
}

.recruitment-request-create-page__cancel-dialog {
  width: min(460px, calc(100vw - 24px));
  border-radius: 10px;
  padding: 4px;
  box-sizing: border-box;
}

.recruitment-request-create-page__cancel-header {
  min-height: 44px;
  border-radius: 6px;
  padding: 8px 12px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: linear-gradient(90deg, rgba(115, 103, 240, 1) 0%, rgba(115, 103, 240, 0.7) 100%);
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 20px;
  font-weight: 400;
  color: var(--color-bg-white);
}

.recruitment-request-create-page__cancel-close {
  color: var(--color-bg-white);
  min-width: auto;
  padding: 0;
}

.recruitment-request-create-page__cancel-text {
  padding: 16px;
  font-family: var(--font-family-roboto);
  font-size: 16px;
  line-height: 24px;
  color: var(--color-text-primary);
}

.recruitment-request-create-page__cancel-actions {
  padding: 0 16px 12px;
  gap: 16px;
  justify-content: space-between;
  display: flex;
  flex-wrap: nowrap;
}

.recruitment-request-create-page__cancel-actions :deep(.app-button) {
  min-width: 0;
  flex: 1 1 0;
}

:global(.q-dialog__backdrop) {
  background: rgba(0, 0, 0, 0.25) !important;
  opacity: 1 !important;
}

:global(.q-dialog) {
  z-index: 7000 !important;
}

:global(.q-dialog__inner) {
  z-index: 7001 !important;
}
</style>
