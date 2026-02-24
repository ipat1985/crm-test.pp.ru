<template>
  <section class="checkbox-integration">
    <div class="checkbox-integration__fields">
      <h4 class="checkbox-integration__title">Активные поля</h4>

      <Checkbox
        v-for="field in fields"
        :key="field.key"
        v-model="field.enabled"
        :label="field.label"
        description=""
        size="md"
        class="checkbox-integration__checkbox"
      />
    </div>

    <div class="checkbox-integration__codes">
      <div class="checkbox-integration__code-block">
        <h4 class="checkbox-integration__title">Разместить в необходимом месте в тег body:</h4>
        <div class="checkbox-integration__code">
          <code>{{ bodyWidgetSnippet }}</code>
          <button type="button" class="checkbox-integration__copy-btn" @click="copySnippet(bodyWidgetSnippet)">
            <q-icon name="o_content_copy" />
          </button>
        </div>
      </div>

      <div class="checkbox-integration__code-block">
        <h4 class="checkbox-integration__title">Разместить в конце содержимого тега body :</h4>
        <div class="checkbox-integration__code checkbox-integration__code--multiline">
          <code>{{ bodyScriptSnippet }}</code>
          <button type="button" class="checkbox-integration__copy-btn" @click="copySnippet(bodyScriptSnippet)">
            <q-icon name="o_content_copy" />
          </button>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Checkbox from './Checkbox.vue';

defineOptions({ name: 'CheckboxIntegration' });

const fields = ref([
  { key: 'phone', label: 'Номер телефона', enabled: true },
  { key: 'surname', label: 'Фамилия', enabled: false },
  { key: 'name', label: 'Имя', enabled: true },
  { key: 'middle', label: 'Отчество', enabled: false },
  { key: 'city', label: 'Город', enabled: true },
]);

const bodyWidgetSnippet = `<div id="widget-form-body" partner-id="5"></div>`;
const bodyScriptSnippet = [
  '<scr' + 'ipt type="text/javascript" src="https://crm.handswork.pro/workers-form/dist/jquery-3.5.0.min.js"></scr' + 'ipt>',
  '<scr' + 'ipt type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.maskedinput/1.4.1/jquery.maskedinput.min.js"></scr' + 'ipt>',
  '<scr' + 'ipt type="text/javascript" src="https://crm.handswork.pro/workers-form/dist/script.js"></scr' + 'ipt>',
].join('\n');

function copySnippet(text: string): void {
  if (!navigator?.clipboard) return;
  void navigator.clipboard.writeText(text);
}
</script>

<style scoped lang="scss">
.checkbox-integration {
  width: 100%;
  display: grid;
  grid-template-columns: 1fr minmax(420px, 2fr);
  gap: 20px;
}

.checkbox-integration__title {
  margin: 0 0 8px;
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 22px;
  font-weight: 500;
  color: var(--color-text-primary);
}

.checkbox-integration__fields {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.checkbox-integration__checkbox {
  height: 38px;
  min-height: 38px;
  display: inline-flex;
  align-items: center;
}

.checkbox-integration__checkbox :deep(.checkbox) {
  padding: 0;
}

.checkbox-integration__checkbox :deep(.checkbox__label) {
  font-family: var(--font-family-primary);
  font-size: 14px;
  line-height: 20px;
}

.checkbox-integration__checkbox :deep(.checkbox__description) {
  display: none;
}

.checkbox-integration__codes {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.checkbox-integration__code-block {
  display: flex;
  flex-direction: column;
}

.checkbox-integration__code {
  position: relative;
  border: 1px solid var(--input-border-color, #2f2b3d38);
  border-radius: 10px;
  background: var(--color-bg-white);
  padding: 14px 44px 14px 16px;
  min-height: 56px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
}

.checkbox-integration__code--multiline {
  align-items: flex-start;
}

.checkbox-integration__code code {
  font-family: var(--font-family-roboto);
  font-size: 14px;
  line-height: 24px;
  color: var(--color-text-secondary);
  white-space: pre-wrap;
  word-break: break-word;
}

.checkbox-integration__copy-btn {
  position: absolute;
  right: 12px;
  top: 12px;
  border: 0;
  background: transparent;
  color: var(--color-primary-main);
  cursor: pointer;
  padding: 0;
  width: 24px;
  height: 24px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
</style>
