<template>
  <div class="flex flex-wrap gap-3 mt-5">
    <draggable v-model="draggableFields" item-key="data_field.id" class="flex flex-wrap gap-3" :animation="200"
      ghost-class="opacity-50" @end="updateFormIndexes" :key="draggableKey">
      <template #item="{ element: fixtureListField }">
        <div class="flex-none" :key="`${fixtureListField?.data_field?.id}-${draggableKey}`">
          <button type="button"
            class="inline-flex items-center cursor-pointer border focus:outline-none rounded-lg animated"
            @click="openFiltersModal(fixtureListField)" :class="[
              fixtureListField.hasFiltersApplied
                ? 'bg-green-500 hover:bg-green-500/90 text-white border-green-500 font-semibold'
                : 'bg-white hover:bg-gray-100 dark:bg-neutral-950 dark:hover:bg-neutral-900 border-gray-200 dark:border-neutral-700'
            ]" v-if="fixtureListField?.data_field">
            <span class="px-3 py-2.5">
              {{ $t(`data_fields.${fixtureListField?.data_field?.code}`) }}
            </span>

            <span
              class="material-symbols-outlined !text-xl px-3 py-1 text-black/60 dark:text-white/60 hover:text-black dark:hover:text-white dark:text-neutral-500"
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
import { cloneDeep } from 'lodash-es'

const props = defineProps({ metaData: Object })
const form = inject('form')

const {
  toggleItem: toggleField,
  availableItems: availableFields,
} = useFixtureList(form, props, 'fixture_list_fields_attributes', 'data_field', ['code'])

const modals = reactive({})
const draggableFields = ref([])
const draggableKey = ref(0) // fuerza reinicio

watch(
  () => availableFields.value ?? availableFields,
  (newVal) => {
    draggableFields.value = Array.isArray(newVal) ? cloneDeep(newVal) : []
    draggableKey.value++ // reinicia el componente y sus hijos
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
