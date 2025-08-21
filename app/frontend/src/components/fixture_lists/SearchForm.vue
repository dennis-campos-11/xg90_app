<template>
  <div class="mb-10">
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
import { inject, watch, computed, ref } from 'vue'
import FiltersInputs from './FiltersInputs.vue'
import FieldTags from './FieldTags.vue'
import FixtureListsDropdown from './FixtureListsDropdown.vue'
import SaveModal from './SaveModal.vue'

const props = defineProps({
  fixtureLists: Array,
  fixtureList: Object,
  metaData: Object
})

const form = inject('form')

const saveModalRef = ref(null)
const emit = defineEmits(['search', 'getAllFixtureLists', 'getFixtureList'])

function hydrateForm(fixtureList) {
  if (fixtureList) {
    Object.assign(form, {
      id: fixtureList.id,
      name: fixtureList.name,
      total_matches: fixtureList.total_matches,
      season_index: fixtureList.season_index,
      home_location: fixtureList.home_location,
      away_location: fixtureList.away_location,
      fixture_list_fields_attributes: (fixtureList.fixture_list_fields).map((
        { data_field, ...rest }  // eslint-disable-line no-unused-vars
      ) => rest),
      fixture_list_competitions_attributes: (fixtureList.fixture_list_competitions).map((
        { competition, ...rest }  // eslint-disable-line no-unused-vars
      ) => rest),
      only_current_competition: fixtureList.only_current_competition,
      show_variance_against_competition: fixtureList.show_variance_against_competition,
      sort: fixtureList.sort
    })
  }
}

const isFormValid = computed(() => {
  return (
    !!form.home_location &&
    !!form.away_location &&
    !!form.total_matches &&
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
  emit('getFixtureList', fixtureList.id)
  emit('getAllFixtureLists')
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
  { immediate: true, deep: true }
)
</script>
