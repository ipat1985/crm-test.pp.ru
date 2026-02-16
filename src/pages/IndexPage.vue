<template>
  <q-page class="flex">
    <PageContainer>
      <div class="row items-center justify-evenly q-mb-lg">
      <example-component
      title="Example component"
      active
      :todos="todos"
      :meta="meta"
    ></example-component>
    </div>

    <!-- Card с Avatar, Button, ButtonGroup -->
    <Card
      header-title="Title"
      header-subtitle="Subtitle"
      class="q-mx-auto"
      style="max-width: 360px"
    >
      <template #media>
        <div
          class="bg-grey-4 flex items-center justify-center"
          style="height: 180px; color: var(--color-text-secondary)"
        >
          Put the image you want here
        </div>
      </template>
      <h6 class="q-ma-none q-mb-sm" style="font-size: 20px">Title</h6>
      <p class="q-ma-none q-mb-sm text-body2" style="color: var(--color-text-secondary)">
        by Subtitle
      </p>
      <p class="q-ma-none text-body2" style="color: var(--color-text-secondary)">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit...
      </p>
      <template #actions>
        <ButtonGroup variant="flat" :grouped="false">
          <Button label="Action 1" variant="flat" />
          <Button label="Action 2" variant="flat" />
        </ButtonGroup>
      </template>
    </Card>
    </PageContainer>
  </q-page>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import type { Todo, Meta } from 'components/models';
import ExampleComponent from 'components/ExampleComponent.vue';
import PageContainer from 'components/layout/PageContainer.vue';

const todos = ref<Todo[]>([
  {
    id: 1,
    content: 'ct1',
  },
  {
    id: 2,
    content: 'ct2',
  },
  {
    id: 3,
    content: 'ct3',
  },
  {
    id: 4,
    content: 'ct4',
  },
  {
    id: 5,
    content: 'ct5',
  },
]);

const meta = ref<Meta>({
  totalCount: 1200,
});
</script>
