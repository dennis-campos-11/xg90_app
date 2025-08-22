<template>
  <div class="mt-5">
    <div class="flex gap-1">
      <button type="button"
        class="inline-flex items-center cursor-pointer focus:outline-none rounded-lg px-3 py-2"
        v-for="date in metaData?.dates"
        :key="date.id"
        :class="[
        form.fixture_date === date.id
          ? 'font-medium bg-gray-900 hover:bg-gray-800 text-white dark:text-black dark:bg-white dark:hover:bg-gray-200'
          : 'hover:bg-gray-200 dark:hover:bg-neutral-800'
        ]"
        @click="setDate(date)"
      >
        {{ date.value }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { inject } from 'vue'

defineProps({ metaData: Object })
const form = inject('form')

const setDate = (date) => {
  form.fixture_date = date.id
}
</script>
