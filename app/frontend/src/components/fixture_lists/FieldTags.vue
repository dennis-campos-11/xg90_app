<template>
  <div class="mt-5">
    <draggable v-model="draggableFields" item-key="data_field.id" class="flex flex-wrap gap-3" :animation="200"
      ghost-class="opacity-50" @end="updateFormIndexes" :key="draggableKey">
      <template #item="{ element: fixtureListField }">
        <div class="flex-none" :key="`${fixtureListField?.data_field?.id}-${draggableKey}`">
          <button type="button"
            class="inline-flex items-center cursor-pointer focus:outline-none rounded-lg animated"
            @click="openFiltersModal(fixtureListField)" :class="[
              fixtureListField.hasFiltersApplied
                ? 'font-medium bg-gray-900 hover:bg-gray-800 text-white dark:text-black dark:bg-white dark:hover:bg-gray-200'
                : 'bg-gray-100 hover:bg-gray-200 dark:bg-neutral-900 dark:hover:bg-neutral-800'
            ]" v-if="fixtureListField?.data_field">
            <span class="px-3 pr-0">
              {{ $t(`data_fields.${fixtureListField?.data_field?.code}`) }}
            </span>

            <span class="material-symbols-outlined !text-xl px-3 py-1 hover:text-red-500 dark:hover:text-red-600"
              @click.stop="toggleField(fixtureListField?.data_field)">
              close
            </span>
          </button>

          <FiltersModal :fixture-list-field="fixtureListField"
            :ref="el => setModalRef(fixtureListField.data_field.id, el)"
            :key="`modal-${fixtureListField?.data_field?.id}-${draggableKey}`" v-if="fixtureListField?.data_field" />
        </div>
      </template>
    </draggable>
  </div>
</template>

<script setup>
import { inject, reactive, ref, watch } from 'vue'
import { useFixtureList } from '@/composables/useFixtureList'
import FiltersModal from './FiltersModal.vue'
import draggable from 'vuedraggable'

const props = defineProps({ metaData: Object })
const form = inject('form')

const {
  toggleItem: toggleField,
  availableItems: availableFields,
} = useFixtureList(form, props, 'fixture_list_fields_attributes', 'data_field', ['code'])

const modals = reactive({})
const draggableFields = ref([])
const draggableKey = ref(0)

watch(
  () => availableFields.value ?? availableFields,
  (newVal) => {
    draggableFields.value = Array.isArray(newVal) ? newVal : []
    draggableKey.value++
  },
  { immediate: true }
)

const setModalRef = (id, el) => {
  if (el) modals[id] = el
}

const openFiltersModal = (fixtureListField) => {
  modals[fixtureListField.data_field.id]?.open()
}

function updateFormIndexes() {
  draggableFields.value.forEach((field, index) => {
    const formField = form.fixture_list_fields_attributes.find(
      f => f.data_field_id === field.data_field.id
    )
    if (formField) {
      formField.index = index
    }
  })
}
</script>
