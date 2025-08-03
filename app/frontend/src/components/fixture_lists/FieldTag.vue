<template>
  <div class="flex-none" v-if="!modelValue._destroy">
    <!-- Botón que abre el modal -->
    <button
      type="button"
      class="inline-flex items-center cursor-pointer border border-gray-200 focus:outline-none rounded-lg hover:bg-gray-100 dark:hover:bg-neutral-900 dark:border-neutral-800 animated"
      @click="openFiltersModal"
    >
      <span class="font-medium px-3 py-2">
        {{ $t(`data_fields.${field.data_field.code}`) }}
      </span>

      <span
        v-if="hasFiltersApplied"
        class="bg-green-500 h-2 w-2.5 rounded-full"
      ></span>

      <span
        class="material-symbols-outlined !text-xl px-3 py-1 text-gray-400 hover:text-red-600 dark:text-neutral-500"
        @click.stop="$emit('remove')"
      >
        close
      </span>
    </button>

    <!-- Modal -->
    <FieldFilterModal
      ref="modalRef"
      v-model="filtersLocal"
      :field="field"
      :modal-id="`fieldFilterModal-${field.data_field.id}`"
    />
  </div>
</template>

<script setup>
import { computed, ref, watch, onMounted } from "vue"
import FieldFilterModal from "./FieldFilterModal.vue"

const props = defineProps({
  modelValue: Object,
  field: Object,
})

const emit = defineEmits(["update:modelValue", "remove"])

const modalRef = ref(null)
const filtersLocal = ref({})

const fieldSettings = computed(() => props.field.data_field.settings || {})

const hasFiltersApplied = computed(() => {
  for (const key in fieldSettings.value) {
    const config = fieldSettings.value[key]
    const field = filtersLocal.value[key]
    if (!field) continue

    const { home, away } = field
    if (home.from !== config.min || home.to !== config.max) return true
    if (away.from !== config.min || away.to !== config.max) return true
  }
  return false
})

onMounted(() => {
  filtersLocal.value = props.modelValue
})

watch(
  filtersLocal,
  () => {
    emit("update:modelValue", {
      ...props.modelValue,
      filters: filtersLocal.value,
    })
  },
  { immediate: true, deep: true }
)

const openFiltersModal = () => {
  modalRef.value?.openModal()
}
</script>
