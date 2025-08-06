<template>
  <div class="flex flex-wrap gap-3 mt-5">
    <draggable
      v-model="draggableFields"
      item-key="data_field.id"
      class="flex flex-wrap gap-3"
      :animation="200"
      ghost-class="opacity-50"
      @end="updateFormIndexes"
    >
      <template #item="{ element: fixtureListField }">
        <div class="flex-none" :key="fixtureListField?.data_field?.id">
          <button
            type="button"
            class="inline-flex items-center cursor-pointer border border-gray-200 focus:outline-none rounded-lg dark:border-neutral-800 animated"
            @click="openFiltersModal(fixtureListField)" 
            :class="[
              fixtureListField.hasFiltersApplied
                ? 'text-white bg-gray-950 hover:bg-gray-800 dark:text-black dark:bg-neutral-50 dark:hover:bg-neutral-300'
                : 'bg-white hover:bg-gray-100 dark:bg-black dark:hover:bg-neutral-900'
            ]"
            v-if="fixtureListField?.data_field"
          >
            <span class="px-3 py-2.5">
              {{ $t(`data_fields.${fixtureListField?.data_field?.code}`) }}
            </span>

            <span
              class="material-symbols-outlined !text-xl px-3 py-1 text-inherit hover:text-red-600 dark:text-neutral-500"
              @click.stop="toggleField(fixtureListField?.data_field)"
            >
              close
            </span>
          </button>

          <FiltersModal
            :fixture-list-field="fixtureListField"
            :ref="el => setModalRef(fixtureListField.data_field.id, el)"
            v-if="fixtureListField?.data_field"
          />
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

// inicializar draggableFields como copia del array de availableFields
watch(
  () => availableFields.value ?? availableFields,
  (newVal) => {
    draggableFields.value = Array.isArray(newVal) ? [...newVal] : []
  },
  { immediate: true }
)

const setModalRef = (id, el) => {
  if (el) modals[id] = el
}

const openFiltersModal = (fixtureListField) => {
  modals[fixtureListField.data_field.id]?.open()
}

const updateFormIndexes = () => {
  // reasignamos el array del form con el mismo orden de draggableFields
  form.fixture_list_fields_attributes = draggableFields.value.map((field, index) => {
    const formField = form.fixture_list_fields_attributes.find(
      f => f.data_field_id === field.data_field.id
    )
    return {
      ...formField,
      index: index,
    }
  })
}
</script>

