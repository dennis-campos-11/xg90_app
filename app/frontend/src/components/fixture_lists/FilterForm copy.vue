<template>
  <div class="flex mb-5">
    <FixtureListsDropdown
      :fixture-lists="fixtureLists"
      :selected-fixture-list="selectedFixtureList"
      @selectFixtureList="selectFixtureList"
    />
  </div>

  <form @submit.prevent="submitForm" @keydown.enter.prevent class="space-y-6 mb-6">
    <div class="grid grid-cols-1 md:grid-cols-3 xl:grid-cols-5 gap-4">

      <DropdownRadio id="home-location" :label="$t('fixture_lists.home_location.label')"
        :items="fixtureListMeta.home_locations" v-model="form.home_location"
        translate-key="fixture_lists.home_location.values" />

      <DropdownRadio id="away-location" :label="$t('fixture_lists.away_location.label')"
        :items="fixtureListMeta.away_locations" v-model="form.away_location"
        translate-key="fixture_lists.away_location.values" />

      <DropdownRadio id="sample" :label="$t('fixture_lists.sample.label')" :items="fixtureListMeta.samples"
        v-model="form.sample" translate-key="fixture_lists.sample.values" />

      <DropdownCheckbox id="fields"
        :title="$t('fixture_lists.fields.total', { total: activeData(selectedFields).length })"
        :items="fixtureListMeta.data_fields" :selected-items="activeData(selectedFields)"
        :search-placeholder="$t('fixture_lists.fields.search_placeholder')" label-key="code" @toggle="toggleField" />

      <DropdownCheckbox id="competitions"
        :title="$t('fixture_lists.competitions.total', { total: activeData(selectedCompetitions).length })"
        :items="fixtureListMeta.competitions" :selected-items="activeData(selectedCompetitions)"
        :search-placeholder="$t('fixture_lists.competitions.search_placeholder')" label-key="name"
        @toggle="toggleCompetition" />

      <!-- Switches -->
      <div class="relative flex items-center">
        <label class="inline-flex items-center cursor-pointer">
          <input type="checkbox" v-model="form.only_current_competition" class="sr-only peer" />
          <div
            class="relative w-11 h-6 bg-gray-300 rounded-full peer dark:bg-neutral-700 peer-checked:bg-violet-600 after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border after:border-neutral-300 peer-checked:after:border-violet-700 after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-full">
          </div>
          <span class="ms-3 text-sm font-medium">{{ $t('fixture_lists.only_current_competition.label') }}</span>
        </label>
      </div>

      <div class="relative flex items-center">
        <label class="inline-flex items-center cursor-pointer">
          <input type="checkbox" v-model="form.show_variance_against_competition" class="sr-only peer" />
          <div
            class="relative w-11 h-6 bg-gray-300 rounded-full peer dark:bg-neutral-700 peer-checked:bg-violet-600 after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border after:border-neutral-300 peer-checked:after:border-violet-700 after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-full">
          </div>
          <span class="ms-3 text-sm font-medium">{{ $t('fixture_lists.show_variance_against_competition.label')
            }}</span>
        </label>
      </div>
    </div>

    <!-- Render de tags -->
    <div v-if="activeData(selectedFields).length > 0" class="mt-10">
      <div class="font-medium mb-2">Selected Fields</div>
      <div class="flex flex-wrap gap-2 overflow-x-auto">
        <FieldTag v-for="(field, idx) in activeData(selectedFields)" :key="`tag-${field.data_field.id}`"
          v-model="form.fixture_list_fields_attributes[idx]" :field="field" @remove="toggleField(field.data_field)" />
      </div>
    </div>

    <div class="relative flex gap-3">
      <button type="submit" :disabled="!isFormValid" @click="formAction = 'query'" class="bg-violet-600 text-white px-4 py-2 rounded-lg 
         hover:bg-violet-700 focus-visible:ring-4 focus:outline-none 
         focus-visible:ring-violet-300 dark:focus-visible:ring-violet-800 
         disabled:opacity-50 animated">
        {{ $t('miscellaneous.search') }}
      </button>

      <button type="button" :disabled="!isFormValid" @click="openModal" class="bg-violet-600 text-white px-4 py-2 rounded-lg 
         hover:bg-violet-700 focus-visible:ring-4 focus:outline-none 
         focus-visible:ring-violet-300 dark:focus-visible:ring-violet-800 
         disabled:opacity-50 animated">
        {{ $t(`miscellaneous.${saveActionType}`) }}
      </button>
    </div>

    <SaveModal
      v-if="isModalOpen"
      v-model="form.name"
      :action-type="saveActionType"
      :errors="saveModalErrors"
      @close="isModalOpen = false"
    />
  </form>
</template>

<script setup>
import { reactive, ref, watch, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { initDropdowns } from 'flowbite'
import FixtureListsDropdown from './FixtureListsDropdown.vue'
import FieldTag from './FieldTag.vue'
import DropdownRadio from './DropdownRadio.vue'
import DropdownCheckbox from './DropdownCheckbox.vue'
import SaveModal from "./SaveModal.vue"
import { showAlert } from "@/stores/alert"
import fixtureListsApi from '@/api/fixture_list'

defineOptions({ name: 'FixtureListForm' })

const props = defineProps({
  fixtureLists: Array,
  selectedFixtureList: Object,
  fixtureListMeta: Object
})

const router = useRouter()
const isModalOpen = ref(false)
const formAction = ref(null)
const saveModalErrors = ref({})
const selectedFields = ref([])
const selectedCompetitions = ref([])
const emit = defineEmits(['handleQuery', 'getAllFixtureLists', 'getFixtureList'])

const form = reactive({
  name: null,
  sample: null,
  home_location: null,
  away_location: null,
  fixture_list_fields_attributes: [],
  fixture_list_competitions_attributes: [],
  only_current_competition: false,
  show_variance_against_competition: false
})

onMounted(() => initDropdowns())

const selectFixtureList = (fixtureList) => {
  emit('getFixtureList', fixtureList.id)
}

const activeData = (collection) => {
  return collection?.filter(f => !f._destroy) || []
}

const openModal = () => {
  formAction.value = 'save'
  isModalOpen.value = true
}

const saveActionType = computed(() =>
  props.selectedFixtureList?.id ? 'update' : 'create'
)

const isFormValid = computed(() => {
  return (
    !!form.home_location &&
    !!form.away_location &&
    !!form.sample &&
    activeData(selectedFields.value).length > 0
  )
})

function toggleField(field) {
  if (hasField(field.id)) {
    handleRemove(form.fixture_list_fields_attributes, selectedFields, 'data_field_id', field.id)
  } else {
    selectedFields.value.push({ data_field: field, filters: {} })
    form.fixture_list_fields_attributes.push({
      id: null,
      data_field_id: field.id,
      index: null,
      filters: {},
      _destroy: false,
    })
  }
}

function toggleCompetition(competition) {
  if (hasCompetition(competition.id)) {
    handleRemove(form.fixture_list_competitions_attributes, selectedCompetitions, 'competition_id', competition.id)
  } else {
    selectedCompetitions.value.push({ competition })
    form.fixture_list_competitions_attributes.push({
      id: null,
      competition_id: competition.id,
      _destroy: false,
    })
  }
}

function handleRemove(collection, selectedCollection, idKey, compareId) {
  const collectionIndex = collection.findIndex(item => item[idKey] === compareId)
  const collectionElement = collection[collectionIndex]

  const selectedCollectionIndex = selectedCollection.value.findIndex(item => (item.data_field?.id || item.competition?.id) === compareId)
  const selectedCollectionElement = selectedCollection.value[collectionIndex]

  if (collectionElement.id) {
    collectionElement._destroy = !collectionElement._destroy
  } else {
    collection.splice(collectionIndex, 1)
  }

  if (selectedCollectionElement.id) {
    selectedCollectionElement._destroy = !selectedCollectionElement._destroy
  } else {
    selectedCollection.value.splice(selectedCollectionIndex, 1)
  }
}

function hasField(id) {
  return selectedFields.value.some(f => f.data_field.id === id)
}

function hasCompetition(id) {
  return selectedCompetitions.value.some(c => c.id === id)
}

watch(
  () => props.selectedFixtureList,
  (newVal) => {
    if (!newVal) return

    const simpleFields = [
      'id',
      'name',
      'sample',
      'home_location',
      'away_location',
      'only_current_competition',
      'show_variance_against_competition'
    ]
    simpleFields.forEach(key => {
      form[key] = newVal[key] ?? null
    })

    const fixture_list_field = newVal.fixture_list_fields || []
    form.fixture_list_fields_attributes = fixture_list_field.map(lf => ({
      id: lf.id,
      data_field_id: lf.data_field.id,
      filters: lf.filters,
      index: lf.index,
      _destroy: lf._destroy
    }))
    selectedFields.value = fixture_list_field.map(lf => ({
      id: lf.id,
      data_field: lf.data_field,
      filters: lf.filters,
      index: lf.index,
      _destroy: lf._destroy
    }))

    const fixture_list_competition = newVal.fixture_list_competitions || []
    form.fixture_list_competitions_attributes = fixture_list_competition.map(lc => ({
      id: lc.id,
      competition_id: lc.competition.id,
      _destroy: lc._destroy
    }))
    selectedCompetitions.value = fixture_list_competition.map(lc => ({
      id: lc.id,
      competition: lc.competition
    }))
  },
  { immediate: true, deep: true }
)

function submitForm() {
  if (isFormValid.value) {
    if (formAction.value === 'query') {
      emit('handleQuery', form)
    } else if (formAction.value === 'save') {
      handleSaveFixtureList(form)
    }
  }
}

const handleSaveFixtureList = async (params = {}) => {
  try {
    const id = props.selectedFixtureList?.id
    const action = id ? 'update' : 'create'

    const data = await fixtureListsApi[action](
      ...(id
        ? [id, { fixture_list: params }]
        : [{ fixture_list: params }])
    )

    const fixtureListId = data.fixture_list.id

    isModalOpen.value = false
    saveModalErrors.value = {}

    emit('getAllFixtureLists')
    emit('getFixtureList', fixtureListId)

    showAlert(data?.message, 'success')
    router.push(`/fixture_lists/${fixtureListId}`)
  } catch (error) {
    saveModalErrors.value = error?.errors || {}
    showAlert(error?.message || 'Error inesperado', 'error')
  }
}

</script>
