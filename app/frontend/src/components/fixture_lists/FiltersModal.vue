<template>
  <div :id="modalId" tabindex="-1" aria-hidden="true"
    class="hidden fixed inset-0 z-50 flex items-center justify-center">
    <div
      class="relative bg-white border border-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-700 w-full max-w-2xl max-h-full">
      <div class="flex items-center justify-between p-4 border-b border-gray-200 dark:border-neutral-700">
        <h3 class="text-lg font-medium">
          {{ $t(`data_fields.${fixtureListField.data_field.code}`) }}
        </h3>
        <button type="button"
          class="material-symbols-outlined text-gray-400 dark:text-neutral-400 hover:text-gray-900 dark:hover:text-neutral-600"
          @click="close">
          close
        </button>
      </div>

      <div class="p-6 space-y-10">
        <div v-for="(filterValue, key) in localFilters" :key="key" class="space-y-3">
          <div class="font-medium">
            {{ $t(`fixtures.metrics.${key}.label`) }}
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
            <div v-for="team in ['home', 'away']" :key="team">
              <div class="flex mb-5">
                <span
                  class="inline-flex items-center px-3 bg-gray-200 border rounded-e-0 border-gray-200 border-e-0 rounded-s-md dark:bg-neutral-800 dark:border-neutral-700">
                  {{ $t(`fixture_lists.filters.locations.${team}`) }}
                </span>
                <input type="number" v-model.number="localFilters[key][team].from"
                  class="rounded-none text-center z-10 bg-gray-50 border focus:ring-blue-500 focus:border-blue-500 block flex-1 min-w-0 w-full border-gray-200 p-2.5 dark:bg-neutral-900 dark:border-neutral-700 dark:placeholder-neutral-400 dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  :min="fixtureListField.data_field.settings?.[key]?.min"
                  :max="fixtureListField.data_field.settings?.[key]?.max" step="0.01" />
                <span
                  class="inline-flex items-center px-3 bg-gray-200 border-y border-gray-200 dark:bg-neutral-800 dark:border-neutral-700">
                  to
                </span>
                <input type="number" v-model.number="localFilters[key][team].to"
                  class="rounded-none text-center z-10 rounded-e-lg bg-gray-50 border focus:ring-blue-500 focus:border-blue-500 block flex-1 min-w-0 w-full border-gray-200 p-2.5 dark:bg-neutral-900 dark:border-neutral-700 dark:placeholder-neutral-400 dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  :min="fixtureListField.data_field.settings?.[key]?.min"
                  :max="fixtureListField.data_field.settings?.[key]?.max" step="0.01" />
              </div>

              <!-- Range Slider -->
              <Slider :model-value="[localFilters[key][team].from, localFilters[key][team].to]" @update:modelValue="val => {
                localFilters[key][team].from = val[0]
                localFilters[key][team].to = val[1]
              }" 
                :min="fixtureListField.data_field.settings?.[key]?.min"
                :max="fixtureListField.data_field.settings?.[key]?.max" :step="-1" :range="true" show-tooltip="drag"
                tooltip-position="bottom" class="
                  [--slider-connect-bg:#155dfc]
                  [--slider-connect-bg-hover:#2563eb]
                  [--slider-rail-bg:#bfdbfe]
                  [--slider-thumb-bg:#155dfc]
                  [--slider-thumb-bg-hover:#2563eb]
                  [--slider-thumb-border:#155dfc]
                  [--slider-handle-shadow:0_0_0_3px_#155dfc]
                  [--slider-tooltip-bg:#155dfc]
                  [--slider-tooltip-color:white]
                " />
            </div>
          </div>
        </div>
      </div>

      <div class="flex justify-end gap-3 p-4 border-t border-gray-200 dark:border-neutral-700">
        <button type="button"
          class="px-4 py-2 rounded-lg bg-gray-200 dark:bg-neutral-800 hover:bg-gray-300 dark:hover:bg-neutral-700"
          @click="close">
          Cancel
        </button>
        <button type="button" class="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700"
          @click="applyFilters">
          Apply
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from 'vue'
import { Modal } from 'flowbite'
import Slider from "@vueform/slider"

const props = defineProps({
  fixtureListField: Object
})

const form = inject('form')
const modalInstance = ref(null)
const modalId = `modal-${props.fixtureListField.data_field.id}`
const localFilters = ref({})

onMounted(() => {
  localFilters.value = buildFilters()
  const $targetEl = document.getElementById(modalId)
  if ($targetEl) {
    modalInstance.value = new Modal($targetEl, {
      backdrop: 'static',
      backdropClasses: 'bg-gray-900/50 dark:bg-neutral-900/80 fixed inset-0 z-40'
    })
  }
})

function buildFilters() {
  let filters = props.fixtureListField.filters || {}
  if (Object.keys(filters).length > 0) return filters

  const settings = props.fixtureListField.data_field.settings
  const newFilters = {}

  Object.keys(settings).forEach(key => {
    const { min, max } = settings[key]
    newFilters[key] = {
      home: { from: min, to: max },
      away: { from: min, to: max }
    }
  })

  return newFilters
}

const applyFilters = () => {
  const targetField = form.fixture_list_fields_attributes.find(
    f => f.data_field_id === props.fixtureListField.data_field.id
  )
  if (targetField) {
    targetField.filters = JSON.parse(JSON.stringify(localFilters.value))
  }
  close()
}

const open = () => modalInstance.value?.show()
const close = () => modalInstance.value?.hide()
defineExpose({ open, close })
</script>
