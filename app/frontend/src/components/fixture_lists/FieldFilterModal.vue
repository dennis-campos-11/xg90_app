<template>
  <div
    :id="modalId"
    tabindex="-1"
    aria-hidden="true"
    class="hidden fixed inset-0 z-50 flex items-center justify-center"
  >
    <div
      class="relative bg-white rounded-lg shadow-sm dark:bg-neutral-800 w-full max-w-2xl max-h-full"
    >
      <!-- Header -->
      <div
        class="flex items-center justify-between p-4 border-b dark:border-neutral-700 border-gray-200"
      >
        <h3 class="text-lg font-semibold">
          {{ $t(`data_fields.${field.data_field.code}`) }}
        </h3>
        <button
          type="button"
          class="material-symbols-outlined text-gray-400 dark:text-neutral-400 hover:text-gray-900 dark:hover:text-neutral-600"
          @click="closeModal"
        >
          close
        </button>
      </div>

      <!-- Body -->
      <div class="p-4 space-y-8 overflow-y-auto max-h-[60vh]">
        <div
          v-for="(filterValue, key) in localFilters"
          :key="key"
          class="space-y-4"
        >
          <div class="font-medium">
            {{ $t(`fixtures.metrics.${key}.label`) }}
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
            <div v-for="team in ['home', 'away']" :key="team">
              <label class="block text-sm font-medium mb-2">
                {{ $t(`fixture_lists.filters.locations.${team}`) }}
              </label>
              <Slider
                v-model="localFilters[key][team]"
                :min="field.data_field.settings?.[key].min"
                :max="field.data_field.settings?.[key].max"
                :step="-1"
                show-tooltip="drag"
                class="
                  [--slider-connect-bg:#7c3aed]
                  [--slider-connect-bg-hover:#6d28d9]
                  [--slider-rail-bg:#ede9fe]
                  [--slider-thumb-bg:#7c3aed]
                  [--slider-thumb-bg-hover:#6d28d9]
                  [--slider-thumb-border:#7c3aed]
                  [--slider-handle-shadow:0_0_0_3px_#c4b5fd]
                  [--slider-tooltip-bg:#7c3aed]
                  [--slider-tooltip-color:white]
                "
              />
            </div>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div
        class="flex items-center p-4 border-t border-gray-200 rounded-b dark:border-neutral-700"
      >
        <button
          @click="closeModal"
          type="button"
          class="py-2.5 px-5 text-sm font-medium focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 focus:ring-4 focus:ring-gray-100 dark:focus:ring-neutral-700 dark:bg-neutral-900 dark:text-neutral-400 dark:border-neutral-700 dark:hover:bg-neutral-800"
        >
          {{ $t("miscellaneous.close") }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from "vue"
import Slider from "@vueform/slider"
import { Modal } from "flowbite"

const props = defineProps({
  modelValue: Object,
  field: Object,
  modalId: {
    type: String,
    default: "fieldFilterModal",
  },
})

const emit = defineEmits(["update:modelValue", "close"])

const localFilters = ref({})
const modalInstance = ref(null)

const normalizeRange = (value, config) => {
  if (value) return [Math.min(value.from, value.to), Math.max(value.from, value.to)]
  return [config.min, config.max]
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
      backdropClasses: "bg-gray-900/80 dark:bg-black/80 fixed inset-0 z-40",
    })
  }

  localFilters.value = buildDefaultFilters(props.field.filters || {})
})

watch(
  localFilters,
  () => {
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
    emit("update:modelValue", transformed)
  },
  { immediate: true, deep: true }
)

const openModal = () => modalInstance.value?.show()
const closeModal = () => {
  modalInstance.value?.hide()
  emit("close")
}

defineExpose({ openModal, closeModal })
</script>

