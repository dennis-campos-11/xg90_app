<template>
  <div>
    <div class="flex mb-3 items-center justify-between">
      <FixtureListsDropdown 
        :fixture-lists="fixtureLists" 
        :selected-fixture-list="fixtureList"
        @selectFixtureList="selectFixtureList" />

      <div class="flex gap-3">
        <button type="button" :disabled="!isFormValid" @click="openSaveModal" 
                class="bg-blue-600 text-white px-4 py-2 rounded-lg
                      hover:bg-blue-700 focus-visible:ring-4 focus:outline-none 
                      focus-visible:ring-blue-300 dark:focus-visible:ring-blue-800 
                      disabled:opacity-50 animated"
        >
          {{ $t(`miscellaneous.save`) }}
        </button>
      </div>
    </div>
    
    <FiltersInputs :meta-data="metaData"/>
    <FieldTags :meta-data="metaData"/>
    <SaveModal ref="saveModalRef" @reloadData="reloadData"/>
  </div>
</template>

<script setup>
import { debounce, omit } from 'lodash'
import { reactive, provide, watch, computed, ref } from 'vue'
import FiltersInputs from './FiltersInputs.vue'
import FieldTags from './FieldTags.vue'
import FixtureListsDropdown from './FixtureListsDropdown.vue'
import SaveModal from './SaveModal.vue'
// import FieldTag from './FieldTag.vue'
// import DropdownRadio from './DropdownRadio.vue'
// import DropdownCheckbox from './DropdownCheckbox.vue'
// import SaveModal from "./SaveModal.vue"
// import { showAlert } from "@/stores/alert"
// import fixtureListsApi from '@/api/fixture_list'

const props = defineProps({
  fixtureLists: Array,
  fixtureList: Object,
  metaData: Object
})

const form = reactive({
  id: null,
  name: null,
  sample: null,
  home_location: null,
  away_location: null,
  fixture_list_fields_attributes: [],
  fixture_list_competitions_attributes: [],
  only_current_competition: false,
  show_variance_against_competition: false
})
const saveModalRef = ref(null)
const emit = defineEmits(['search', 'getAllFixtureLists', 'getFixtureList'])

provide('form', form)

function hydrateForm(fixtureList) {
  if (fixtureList) {
    Object.assign(form, {
      id: fixtureList.id,
      name: fixtureList.name,
      sample: fixtureList.sample,
      home_location: fixtureList.home_location,
      away_location: fixtureList.away_location,
      fixture_list_fields_attributes: (fixtureList.fixture_list_fields).map((
        { data_field, ...rest }  // eslint-disable-line no-unused-vars
      ) => rest),
      fixture_list_competitions_attributes: (fixtureList.fixture_list_competitions).map((
        { competition, ...rest }  // eslint-disable-line no-unused-vars
      ) => rest),
      only_current_competition: fixtureList.only_current_competition,
      show_variance_against_competition: fixtureList.show_variance_against_competition
    })
  }
}

const isFormValid = computed(() => {
  return (
    !!form.home_location &&
    !!form.away_location &&
    !!form.sample &&
    form.fixture_list_fields_attributes?.length > 0
  )
})

const search = debounce(() => {
  if (isFormValid.value) {
    emit('search', form)
  }
}, 200)

const formWatched = computed(() => {
  return omit({ ...form }, ['name'])
})

const selectFixtureList = (fixtureList) => {
  emit('getFixtureList', fixtureList.id)
}

const openSaveModal = () => {
  saveModalRef.value?.open()
}

const reloadData = (fixtureList) => {
  emit('getAllFixtureLists')
  emit('getFixtureList', fixtureList.id)
}

watch(
  () => props.fixtureList,
  (newVal) => {
    hydrateForm(newVal)
  },
  { immediate: true }
)

watch(
  formWatched,
  () => {
    search()
  },
  { deep: true }
)
</script>
