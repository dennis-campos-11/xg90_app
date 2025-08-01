<template>
  <div class="flex-none">
    <!-- Botón que abre modal -->
    <button type="button"
      class="inline-flex items-center cursor-pointer border border-gray-200 hover:bg-gray-100 focus:outline-none rounded-lg dark:hover:bg-neutral-900 dark:border-neutral-800 animated"
      @click="openModal">
      <span class="text-sm font-medium px-3 py-2.5">
        {{ $t(`data_fields.${selectedField.data_field.code}`) }}
      </span>

      <!-- Indicador de filtros -->
      <span v-if="hasFiltersApplied" class="bg-violet-500 h-2 w-2 rounded-full ring-3 ring-violet-200">
      </span>

      <!-- Botón para eliminar campo -->
      <span class="material-symbols-outlined !text-lg px-3 py-1.5 text-gray-400 hover:text-red-600 dark:text-neutral-500"
        @click.stop="$emit('remove')">
        close
      </span>
    </button>

    <!-- Modal -->
    <div :id="modalId" tabindex="-1"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
      <div class="relative p-4 w-full max-w-2xl max-h-full">
        <div class="relative bg-white rounded-lg shadow-sm dark:bg-neutral-900">
          <!-- Header -->
          <div
            class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-neutral-800 border-gray-200">
            <h3 class="text-lg font-semibold">
              {{ $t(`data_fields.${selectedField.data_field.code}`) }}
            </h3>
            <button type="button" @click="closeModal" class="text-gray-400 hover:text-gray-900 dark:hover:text-neutral-600">
              ✕
            </button>
          </div>

          <!-- Body -->
          <div class="p-4 md:p-5 space-y-8">
            <div v-for="(filterValue, key) in filtersLocal" :key="key" class="space-y-4">
              <div class="font-medium">{{ $t(`fixtures.metrics.${key}.label`) }}</div>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                <div v-for="team in ['home', 'away']" :key="team">
                  <label class="block text-sm font-medium mb-2">
                    {{ $t(`fixture_lists.filters.locations.${team}`) }}
                  </label>
                  <Slider 
                    v-model="filtersLocal[key][team]"
                    :min="selectedField.data_field.settings?.[key].min"
                    :max="selectedField.data_field.settings?.[key].max"
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
          <div class="flex items-center p-4 md:p-5 border-t border-gray-200 rounded-b dark:border-neutral-800">
            <button @click="closeModal" type="button"
              class="py-2.5 px-5 text-sm font-medium focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-neutral-700 dark:bg-neutral-900 dark:text-neutral-400 dark:border-neutral-800 dark:hover:bg-neutral-800">
              {{ $t("miscellaneous.close") }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Modal } from 'flowbite'
import { ref, inject, onMounted, computed, watch } from 'vue'
import Slider from '@vueform/slider'

const props = defineProps({
  selectedField: Object,
})

const form = inject('form')
const filtersLocal = ref({})
const modalInstance = ref(null)

const modalId = `modal-${props.selectedField.data_field.id}`

const fieldObj = computed(() =>
  form.fixture_list_fields_attributes.find(
    (f) => f.data_field_id === props.selectedField.data_field.id
  )
)

const normalizeRange = (value, config) => {
  if (Array.isArray(value) && value.length === 2) {
    return [Math.min(value[0], value[1]), Math.max(value[0], value[1])]
  }
  if (value && typeof value === 'object' && 'from' in value && 'to' in value) {
    return [Math.min(value.from, value.to), Math.max(value.from, value.to)]
  }
  return [config.min, config.max]
}

onMounted(() => {
  const settings = props.selectedField.data_field.settings || {}
  const existingFilters = props.selectedField.filters || {}

  const filtersDefault = Object.fromEntries(
    Object.entries(settings).map(([key, config]) => [
      key,
      {
        home: normalizeRange(existingFilters[key]?.home, config),
        away: normalizeRange(existingFilters[key]?.away, config),
      },
    ])
  )

  filtersLocal.value = filtersDefault

  if (!fieldObj.value) {
    form.fixture_list_fields_attributes.push({
      id: null,
      data_field_id: props.selectedField.data_field.id,
      index: null,
      filters: {},
      _destroy: false,
    })
  } else {
    fieldObj.value._destroy = false
  }

  // Inicializa modal
  const $targetEl = document.getElementById(modalId)
  if ($targetEl) {
    modalInstance.value = new Modal($targetEl, {
      backdrop: 'static',
      backdropClasses: 'bg-gray-900/80 dark:bg-black/80 fixed inset-0 z-40',
    })
  }
})

// Métodos abrir/cerrar modal
const openModal = () => {
  modalInstance.value?.show()
}
const closeModal = () => {
  modalInstance.value?.hide()
}

// Watch para transformar [from, to] → { from, to }
watch(filtersLocal, () => {
  if (!fieldObj.value) return

  const filtersFormatted = {}
  for (const key in filtersLocal.value) {
    filtersFormatted[key] = {}
    for (const team of ['home', 'away']) {
      const val = filtersLocal.value[key][team]
      filtersFormatted[key][team] = {
        from: Math.min(val[0], val[1]),
        to: Math.max(val[0], val[1]),
      }
    }
  }
  fieldObj.value.filters = filtersFormatted
}, { deep: true })

const hasFiltersApplied = computed(() => {
  const settings = props.selectedField.data_field.settings || {}
  for (const key in settings) {
    const config = settings[key]
    const field = filtersLocal.value[key]
    if (!field) continue
    const home = field.home
    const away = field.away
    if (home[0] !== config.min || home[1] !== config.max) return true
    if (away[0] !== config.min || away[1] !== config.max) return true
  }
  return false
})
</script>
