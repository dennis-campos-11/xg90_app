<template>
  <div :id="modalId" tabindex="-1" aria-hidden="true"
    class="hidden fixed inset-0 z-50 flex items-center justify-center">
    <div
      class="relative bg-white border border-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 w-full max-w-2xl max-h-full">
      <!-- Header -->
      <div class="flex items-center justify-between p-4 border-b dark:border-neutral-800 border-gray-200">
        <h3 class="text-lg font-semibold">
          {{ $t(`data_fields.${field.data_field.code}`) }}
        </h3>
        <button type="button"
          class="material-symbols-outlined text-gray-400 dark:text-neutral-400 hover:text-gray-900 dark:hover:text-neutral-600"
          @click="closeModal">
          close
        </button>
      </div>

      <!-- Body -->
      <div class="p-4 pb-12 space-y-8 overflow-y-auto max-h-[60vh]">
        <div v-for="(filterValue, key) in localFilters" :key="key" class="space-y-2">
          <div class="font-medium">
            {{ $t(`fixtures.metrics.${key}.label`) }}
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
            <div v-for="team in ['home', 'away']" :key="team">
              <div class="flex mb-5">
                <span
                  class="inline-flex items-center px-3 text-sm bg-gray-200 border rounded-e-0 border-gray-200 border-e-0 rounded-s-md dark:bg-neutral-800 dark:border-neutral-800">
                  {{ $t(`fixture_lists.filters.locations.${team}`) }}
                </span>
                <input type="number" v-model.number="localFilters[key][team][0]"
                  class="rounded-none text-center z-10 bg-gray-50 border focus:ring-blue-500 focus:border-blue-500 block flex-1 min-w-0 w-full text-sm border-gray-200 p-2.5 dark:bg-neutral-950 dark:border-neutral-800 dark:placeholder-neutral-400 dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  :min="field.data_field.settings?.[key].min" :max="field.data_field.settings?.[key].max"
                  @blur="localFilters[key][team][0] = ensureNotEmpty(localFilters[key][team][0], field.data_field.settings?.[key].min)"
                  step="0.01" />
                <span
                  class="inline-flex items-center px-3 text-sm bg-gray-200 border-y border-gray-200 dark:bg-neutral-800 dark:border-neutral-800">
                  to
                </span>
                <input type="number" v-model.number="localFilters[key][team][1]"
                  class="rounded-none text-center z-10 rounded-e-lg bg-gray-50 border focus:ring-blue-500 focus:border-blue-500 block flex-1 min-w-0 w-full text-sm border-gray-200 p-2.5 dark:bg-neutral-950 dark:border-neutral-800 dark:placeholder-neutral-400 dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  :min="field.data_field.settings?.[key].min" :max="field.data_field.settings?.[key].max"
                  @blur="localFilters[key][team][1] = ensureNotEmpty(localFilters[key][team][1], field.data_field.settings?.[key].max)"
                  step="0.01" />
              </div>
              <!-- Slider -->
              <Slider
                v-model="localFilters[key][team]"
                :min="field.data_field.settings?.[key].min"
                :max="field.data_field.settings?.[key].max"
                :step="-1"
                show-tooltip="drag"
                tooltip-position="bottom"
                class="
                  [--slider-connect-bg:#155dfc]
                  [--slider-connect-bg-hover:#2563eb]
                  [--slider-rail-bg:#bfdbfe]
                  [--slider-thumb-bg:#155dfc]
                  [--slider-thumb-bg-hover:#2563eb]
                  [--slider-thumb-border:#155dfc]
                  [--slider-handle-shadow:0_0_0_3px_#155dfc]
                  [--slider-tooltip-bg:#155dfc]
                  [--slider-tooltip-color:white]
                "
              />
            </div>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="flex items-center gap-3 p-4 border-t border-gray-200 rounded-b dark:border-neutral-800">
        <button @click="applyFilters" type="button" class="bg-blue-600 text-white px-4 py-2 rounded-lg
          hover:bg-blue-700 focus-visible:ring-4 focus:outline-none
          focus-visible:ring-blue-300 dark:focus-visible:ring-blue-800 
          disabled:opacity-50 animated">
          {{ $t("miscellaneous.apply") }}
        </button>

        <button @click="resetFilters" type="button" class="bg-white px-4 py-2 rounded-lg border border-gray-200
          hover:bg-gray-200 focus-visible:ring-4 focus:outline-none
          dark:bg-neutral-900 dark:hover:bg-neutral-800 dark:border-neutral-800
          focus-visible:ring-blue-300 dark:focus-visible:ring-blue-800 
          disabled:opacity-50 animated flex items-center gap-1">
          <span class="material-symbols-outlined">
            undo
          </span>
          <span>{{ $t("miscellaneous.reset") }}</span>
        </button>

        <button @click="closeModal" type="button" class="bg-white px-4 py-2 rounded-lg border border-gray-200
          hover:bg-gray-200 focus-visible:ring-4 focus:outline-none
          dark:bg-neutral-900 dark:hover:bg-neutral-800 dark:border-neutral-800
          focus-visible:ring-blue-300 dark:focus-visible:ring-blue-800 
          disabled:opacity-50 animated">
          {{ $t("miscellaneous.close") }}
        </button>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted, watch } from "vue"
import Slider from "@vueform/slider"
import { Modal } from "flowbite"

const props = defineProps({
  modelValue: Object,
  field: Object,
  modalId: {
    type: String
  },
})

const emit = defineEmits(["update:modelValue", "close"])
const localFilters = ref({})
const appliedFilters = ref({})
const modalInstance = ref(null)

const normalizeRange = (value, config) => {
  if (value && value.from !== undefined && value.to !== undefined) {
    return [Math.min(value.from, value.to), Math.max(value.from, value.to)]
  }
  return [config.min, config.max]
}

const ensureNotEmpty = (value, fallback) => {
  if (value === null || value === "" || isNaN(value)) {
    return fallback
  }
  return value
}

const buildDefaultFilters = (existingFilters) =>
  Object.fromEntries(
    Object.entries(props.field.data_field.settings || {}).map(([key, config]) => [
      key,
      {
        home: normalizeRange(existingFilters?.[key]?.home, config),
        away: normalizeRange(existingFilters?.[key]?.away, config),
      },
    ])
  )

onMounted(() => {
  const $targetEl = document.getElementById(props.modalId)
  if ($targetEl) {
    modalInstance.value = new Modal($targetEl, {
      backdrop: "static",
      backdropClasses: "bg-gray-900/50 dark:bg-black/80 fixed inset-0 z-40",
    })
  }

  appliedFilters.value = props.modelValue || {}
  localFilters.value = buildDefaultFilters(appliedFilters.value)
})

watch(
  appliedFilters,
  (newVal) => {
    emit("update:modelValue", newVal)
  },
  { deep: true }
)

const resetFilters = () => {
  localFilters.value = buildDefaultFilters({})
}

const applyFilters = () => {
  const transformed = {}
  for (const [filterKey, filterValue] of Object.entries(localFilters.value)) {
    transformed[filterKey] = {}
    for (const [side, range] of Object.entries(filterValue)) {
      if (Array.isArray(range)) {
        transformed[filterKey][side] = { from: range[0], to: range[1] }
      } else {
        transformed[filterKey][side] = range
      }
    }
  }
  appliedFilters.value = transformed
  closeModal()
}

const openModal = () => {
  localFilters.value = buildDefaultFilters(appliedFilters.value)
  modalInstance.value?.show()
}

const closeModal = () => {
  modalInstance.value?.hide()
  emit("close")
}

defineExpose({ openModal, closeModal, ensureNotEmpty })
</script>