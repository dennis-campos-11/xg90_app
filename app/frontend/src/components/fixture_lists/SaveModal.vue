<template>
  <div
    class="fixed inset-0 z-50 flex items-center justify-center bg-gray-900/80 dark:bg-black/50"
  >
    <div
      class="relative bg-white rounded-lg shadow-sm dark:bg-neutral-800 w-full max-w-2xl max-h-full"
    >
      <!-- Header -->
      <div
        class="flex items-center justify-between p-4 border-b dark:border-neutral-700 border-gray-200"
      >
        <h3 class="text-lg font-semibold">
          {{ $t(`fixture_lists.save_modal.title.${actionType}`) }}
        </h3>
        <button
          type="button"
          class="material-symbols-outlined text-gray-400 dark:text-neutral-400 hover:text-gray-900 dark:hover:text-neutral-600"
          @click="$emit('close')"
        >
          close
        </button>
      </div>

      <!-- Body -->
      <div class="p-4 space-y-8 overflow-y-auto max-h-[60vh]">
        <div>
          <label class="block text-sm font-medium">{{ $t("fixture_lists.save_modal.name") }}</label>
          <input type="text" id="name" v-model="localName" placeholder="Name" :class="[
            'mt-1 w-full text-sm bg-white dark:bg-neutral-700 rounded-md focus:ring-violet-500 focus:border-violet-500',
            errors?.name ? 'border-red-500' : 'border-gray-300 dark:border-neutral-600'
          ]">
          <div v-if="errors?.name" class="text-red-500 text-sm">
            <div v-for="msg in errors.name" :key="msg">{{ msg }}</div>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div
        class="flex items-center p-4 border-t border-gray-200 rounded-b dark:border-neutral-700"
      >
        <button
          type="submit"
          class="py-2.5 px-5 font-medium focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 focus:ring-4 focus:ring-gray-100 dark:focus:ring-neutral-700 dark:bg-neutral-800 dark:text-neutral-400 dark:border-neutral-700 dark:hover:bg-neutral-900 animated"
        >
          {{ $t(`miscellaneous.${actionType}`) }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from "vue"

const props = defineProps({
  modelValue: String,
  actionType: String,
  errors: Object
})

const emit = defineEmits(["update:modelValue", "close"])

const localName = ref({})

onMounted(() => {
  localName.value = props.modelValue
})

watch(
  localName,
  () => {
    emit("update:modelValue", localName.value)
  },
  { deep: true }
)

</script>
