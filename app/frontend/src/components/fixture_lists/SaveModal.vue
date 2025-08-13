<template>
  <div id="saveModal" tabindex="-1" aria-hidden="true"
    class="hidden fixed inset-0 z-50 flex items-center justify-center">
    <div
      class="relative bg-white border border-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-700 w-full max-w-2xl max-h-full">
      <div class="flex items-center justify-between p-4 border-b border-gray-200 dark:border-neutral-700">
        <h3 class="text-lg font-medium">
          {{ $t(`fixture_lists.save_modal.title.${action}`) }}
        </h3>
        <button type="button"
          class="material-symbols-outlined text-gray-400 dark:text-neutral-400 hover:text-gray-900 dark:hover:text-neutral-600"
          @click="close">
          close
        </button>
      </div>

      <div class="p-6 space-y-10">
        <div>
          <label class="block font-medium">{{ $t("fixture_lists.save_modal.name") }}</label>
          <input type="text" id="name" v-model="localName" :class="[
            'mt-1 w-full bg-white dark:bg-neutral-700 rounded-md focus:ring-blue-500 focus:border-blue-500',
            errors?.name ? 'border-red-500' : 'border-gray-300 dark:border-neutral-600'
          ]">
          <div v-if="errors?.name" class="text-red-500">
            <div v-for="msg in errors.name" :key="msg">{{ msg }}</div>
          </div>
        </div>
      </div>

      <div class="flex justify-end gap-3 p-4 border-t border-gray-200 dark:border-neutral-700">
        <button type="button"
          class="px-4 py-2 rounded-lg bg-gray-200 dark:bg-neutral-800 hover:bg-gray-300 dark:hover:bg-neutral-700"
          @click="close">
          Cancel
        </button>
        <button type="button" class="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700" @click="saveModal">
          Apply
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from 'vue'
import { useRouter } from 'vue-router'
import { Modal } from 'flowbite'
import { showAlert } from "@/stores/alert"
import fixtureListsApi from '@/api/fixture_list'

const router = useRouter()
const modalInstance = ref(null)
const localName = ref(null)
const errors = ref({})
const action = 'create'
const form = inject('form')

const emit = defineEmits(["reloadData", "close"])

onMounted(() => {
  const $targetEl = document.getElementById("saveModal")
  if ($targetEl) {
    modalInstance.value = new Modal($targetEl, {
      backdrop: 'static',
      backdropClasses: 'bg-gray-900/50 dark:bg-neutral-900/80 fixed inset-0 z-40'
    })
  }
})

const saveModal = async () => {
  try {
    form.name = localName.value
    const id = form?.id
    const action = id ? 'update' : 'create'

    const data = await fixtureListsApi[action](
      ...(id
        ? [id, { fixture_list: form }]
        : [{ fixture_list: form }])
    )

    const fixtureList = data.fixture_list
    errors.value = {}

    emit('reloadData', fixtureList)
    close()

    showAlert(data?.message, 'success')
    router.push(`/fixture_lists/${fixtureList.id}`)
  } catch (error) {
    errors.value = error?.errors || {}
    showAlert(error?.message || 'Error inesperado', 'error')
  }
}

const open = () => {
  localName.value = form?.name || ""
  modalInstance.value?.show()
}
const close = () => modalInstance.value?.hide()
defineExpose({ open, close })
</script>