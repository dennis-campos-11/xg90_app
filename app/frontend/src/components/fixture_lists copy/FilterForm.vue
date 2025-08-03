<template>
  <div class="flex mb-5">
    <div class="relative">
      <button id="dropdownFixtureListsButton" data-dropdown-toggle="dropdownFixtureLists"
        data-dropdown-placement="bottom-start"
        class="w-full hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg p-2 text-3xl font-medium text-center flex items-center justify-between dark:hover:bg-neutral-900 dark:focus-visible:ring-neutral-600 animated"
        type="button">
        <div class="flex">
          <div v-if="selectedFixtureList">
            {{ selectedFixtureList.name }}
          </div>
          <div v-else>{{ $t("fixture_lists.select_fixture_list") }}</div>
        </div>
        <svg class="w-2.5 h-2.5 ms-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
          <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="m1 1 4 4 4-4" />
        </svg>
      </button>
      <div id="dropdownFixtureLists"
        class="w-100 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 dark:divide-neutral-800">
        <ul class="py-3 font-medium" aria-labelledby="dropdownFixtureListsButton">
          <li>
            <router-link to="/fixture_lists"
              class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-neutral-800 flex items-center gap-2">
              <span class="material-symbols-outlined">
                add
              </span>
              <span>{{ $t("fixture_lists.new_fixture_list") }}</span>
            </router-link>
          </li>
        </ul>
        <ul class="py-3 font-medium" aria-labelledby="dropdownFixtureListsButton">
          <li v-for="fixtureList in fixtureLists" :key="'fixture-list-' + fixtureList.id">
            <router-link :to="`/fixture_lists/${fixtureList.id}`"
              class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-neutral-800">{{ fixtureList.name }}</router-link>
          </li>
        </ul>
      </div>
    </div>
  </div>
  <form @submit.prevent="submitForm" class="space-y-6 mb-6">
    <div class="grid grid-cols-1 md:grid-cols-3 xl:grid-cols-5 gap-4">
      <!-- HOME LOCATION -->
      <div class="relative">
        <button id="dropdownHomeLocationButton" data-dropdown-toggle="dropdownHomeLocation"
          data-dropdown-placement="bottom-start"
          class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-5 py-2.5 text-sm text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-800 animated"
          type="button">
          <div class="flex">
            <div>{{ $t('fixture_lists.home_location.label') }}</div>
            <div v-if="form.home_location" class="font-medium">
              : {{ $t(`fixture_lists.home_location.values.${form.home_location}`) }}
            </div>
          </div>
          <svg class="w-2.5 h-2.5 ms-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="m1 1 4 4 4-4" />
          </svg>
        </button>
        <div id="dropdownHomeLocation"
          class="w-55 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 dark:divide-neutral-800">
          <ul class="p-3 text-sm " aria-labelledby="dropdownHomeLocationButton">
            <li v-for="item in fixtureListMeta.home_locations" :key="'home-location-' + item.id">
              <div class="flex items-center ps-2 rounded-sm hover:bg-gray-100 dark:hover:bg-neutral-800">
                <input type="radio" :id="'home-location-' + item.id" :value="item.id" v-model="form.home_location"
                  name="home-location"
                  class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-neutral-800 focus:ring-2 dark:bg-neutral-700 dark:border-neutral-600">
                <label :for="'home-location-' + item.id" class="w-full py-2 ms-2 text-sm font-medium rounded-sm">{{
                  $t(`fixture_lists.home_location.values.${item.id}`) }}</label>
              </div>
            </li>
          </ul>
        </div>
      </div>

      <!-- AWAY LOCATION -->
      <div class="relative">
        <button id="dropdownAwayLocationButton" data-dropdown-toggle="dropdownAwayLocation"
          data-dropdown-placement="bottom-start"
          class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-5 py-2.5 text-sm text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-800 animated"
          type="button">
          <div class="flex">
            <div>{{ $t('fixture_lists.away_location.label') }}</div>
            <div v-if="form.away_location" class="font-medium">
              : {{ $t(`fixture_lists.away_location.values.${form.away_location}`) }}
            </div>
          </div>
          <svg class="w-2.5 h-2.5 ms-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="m1 1 4 4 4-4" />
          </svg>
        </button>
        <div id="dropdownAwayLocation"
          class="w-55 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 dark:divide-neutral-800">
          <ul class="p-3 text-sm " aria-labelledby="dropdownAwayLocationButton">
            <li v-for="item in fixtureListMeta.away_locations" :key="'away-location-' + item.id">
              <div class="flex items-center ps-2 rounded-sm hover:bg-gray-100 dark:hover:bg-neutral-800">
                <input type="radio" :id="'away-location-' + item.id" :value="item.id" v-model="form.away_location"
                  name="away-location"
                  class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-neutral-800 focus:ring-2 dark:bg-neutral-700 dark:border-neutral-600">
                <label :for="'away-location-' + item.id" class="w-full py-2 ms-2 text-sm font-medium rounded-sm">{{
                  $t(`fixture_lists.away_location.values.${item.id}`) }}</label>
              </div>
            </li>
          </ul>
        </div>
      </div>

      <!-- SAMPLE -->
      <div class="relative">
        <button id="dropdownSampleButton" data-dropdown-toggle="dropdownSample" data-dropdown-placement="bottom-start"
          class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-5 py-2.5 text-sm text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-800 animated"
          type="button">
          <div class="flex">
            <div>{{ $t('fixture_lists.sample.label') }}</div>
            <div v-if="form.sample" class="font-medium">
              : {{ $t(`fixture_lists.sample.values.${form.sample}`) }}
            </div>
          </div>
          <svg class="w-2.5 h-2.5 ms-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="m1 1 4 4 4-4" />
          </svg>
        </button>
        <div id="dropdownSample"
          class="w-55 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 dark:divide-neutral-800">
          <ul class="p-3 text-sm " aria-labelledby="dropdownSampleButton">
            <li v-for="item in fixtureListMeta.samples" :key="'sample-location-' + item.id">
              <div class="flex items-center ps-2 rounded-sm hover:bg-gray-100 dark:hover:bg-neutral-800">
                <input type="radio" :id="'sample-' + item.id" :value="item.id" v-model="form.sample" name="sample"
                  class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-neutral-800 focus:ring-2 dark:bg-neutral-700 dark:border-neutral-600">
                <label :for="'sample-' + item.id" class="w-full py-2 ms-2 text-sm font-medium rounded-sm">{{
                  $t(`fixture_lists.sample.values.${item.id}`) }}</label>
              </div>
            </li>
          </ul>
        </div>
      </div>

      <!-- FIELDS -->
      <div class="relative">
        <button id="dropdownFieldsButton" data-dropdown-toggle="dropdownFields" data-dropdown-placement="bottom-start"
          class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-5 py-2.5 text-sm text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-800 animated"
          type="button">
          <div
            v-html="$t('fixture_lists.fields.total', { total: `<span class='font-medium'>${totalSelected(selectedFields, 'Fields')}</span>` })">
          </div>
          <svg class="w-2.5 h-2.5 ms-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="m1 1 4 4 4-4" />
          </svg>
        </button>
        <div id="dropdownFields"
          class="w-80 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 dark:divide-neutral-800">
          <div class="p-3">
            <div class="relative">
              <div class="absolute inset-y-0 rtl:inset-r-0 start-0 flex items-center ps-3 pointer-events-none">
                <svg class="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true"
                  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
                  <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z" />
                </svg>
              </div>
              <input v-model="fieldSearch" type="text" :placeholder="$t('fixture_lists.fields.search_placeholder')"
                class="block w-full p-2 ps-10 text-sm border-0 rounded-lg bg-gray-100 focus-visible:ring-blue-500 focus-visible:border-blue-500 dark:bg-neutral-700 dark:placeholder-neutral-400 dark:focus-visible:ring-blue-500 dark:focus-visible:border-blue-500" />
            </div>
          </div>
          <ul class="h-48 p-3 overflow-y-auto text-sm ">
            <li v-for="field in filteredFields" :key="'field-' + field.id">
              <div class="flex items-center ps-2 rounded-sm hover:bg-gray-100 dark:hover:bg-neutral-800">
                <input :id="`checkbox-field-${field.id}`" type="checkbox" :checked="hasField(field.id)"
                  @change="toggleField(field)"
                  class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-neutral-800 focus:ring-2 dark:bg-neutral-700 dark:border-neutral-600">
                <label :for="`checkbox-field-${field.id}`" class="w-full py-2 ms-2 text-sm font-medium rounded-sm">{{
                  $t(`data_fields.${field.code}`) }}</label>
              </div>
            </li>
          </ul>
          <div class="flex items-center p-3 rounded-b-lg bg-gray-100 dark:bg-white/5">
            <label class="inline-flex items-center cursor-pointer">
              <input type="checkbox" v-model="showOnlySelectedFields" class="sr-only peer">
              <div
                class="relative w-9 h-5 bg-gray-300 peer-focus:outline-none peer-focus-visible:ring-4 peer-focus-visible:ring-blue-300 dark:peer-focus-visible:ring-blue-800 rounded-full peer dark:bg-neutral-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all dark:border-neutral-600 peer-checked:bg-blue-600 dark:peer-checked:bg-blue-600">
              </div>
              <span class="ms-3 text-sm font-medium">Show only selected</span>
            </label>
          </div>
        </div>
      </div>

      <!-- COMPETITIONS -->
      <div class="relative">
        <button id="dropdownCompetitionsButton" data-dropdown-toggle="dropdownCompetitions"
          data-dropdown-placement="bottom-start"
          class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-5 py-2.5 text-sm text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-800 animated"
          type="button">
          <div
            v-html="$t('fixture_lists.competitions.total', { total: `<span class='font-medium'>${totalSelected(selectedCompetitions, 'Competitions')}</span>` })">
          </div>
          <svg class="w-2.5 h-2.5 ms-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="m1 1 4 4 4-4" />
          </svg>
        </button>
        <div id="dropdownCompetitions"
          class="w-80 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 dark:divide-neutral-800">
          <div class="p-3">
            <div class="relative">
              <div class="absolute inset-y-0 rtl:inset-r-0 start-0 flex items-center ps-3 pointer-events-none">
                <svg class="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true"
                  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
                  <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z" />
                </svg>
              </div>
              <input v-model="competitionSearch" type="text"
                :placeholder="$t('fixture_lists.competitions.search_placeholder')"
                class="block w-full p-2 ps-10 text-sm border-0 rounded-lg bg-gray-100 focus-visible:ring-blue-500 focus-visible:border-blue-500 dark:bg-neutral-700 dark:placeholder-neutral-400 dark:focus-visible:ring-blue-500 dark:focus-visible:border-blue-500" />
            </div>
          </div>
          <ul class="h-48 p-3 overflow-y-auto text-sm ">
            <li v-for="competition in filteredCompetitions" :key="'competition-' + competition.id">
              <div class="flex items-center ps-2 rounded-sm hover:bg-gray-100 dark:hover:bg-neutral-800">
                <input :id="`checkbox-competition-${competition.id}`" type="checkbox"
                  :checked="hasCompetition(competition.id)" @change="toggleCompetition(competition)"
                  class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-neutral-800 focus:ring-2 dark:bg-neutral-700 dark:border-neutral-600">
                <label :for="`checkbox-competition-${competition.id}`"
                  class="w-full py-2 ms-2 text-sm font-medium rounded-sm">{{
                    competition.name }}</label>
              </div>
            </li>
          </ul>
          <div class="flex items-center p-3 rounded-b-lg bg-gray-100 dark:bg-white/5">
            <label class="inline-flex items-center cursor-pointer">
              <input type="checkbox" v-model="showOnlySelectedCompetitions" class="sr-only peer">
              <div
                class="relative w-9 h-5 bg-gray-300 peer-focus:outline-none peer-focus-visible:ring-4 peer-focus-visible:ring-blue-300 dark:peer-focus-visible:ring-blue-800 rounded-full peer dark:bg-neutral-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all dark:border-neutral-600 peer-checked:bg-blue-600 dark:peer-checked:bg-blue-600">
              </div>
              <span class="ms-3 text-sm font-medium">Show only selected</span>
            </label>
          </div>
        </div>
      </div>

      <div class="relative flex items-center">
        <label class="inline-flex items-center cursor-pointer">
          <input type="checkbox" v-model="form.only_current_competition" name="only_current_competition"
            class="sr-only peer">
          <div
            class="relative w-11 h-6 bg-gray-300 peer-focus:outline-none peer-focus-visible:ring-4 peer-focus-visible:ring-blue-300 dark:peer-focus-visible:ring-blue-800 rounded-full peer dark:bg-neutral-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-neutral-600 peer-checked:bg-blue-600 dark:peer-checked:bg-blue-600">
          </div>
          <span class="ms-3 text-sm font-medium">{{
            $t('fixture_lists.only_current_competition.label') }}</span>
        </label>
      </div>

      <div class="relative flex items-center">
        <label class="inline-flex items-center cursor-pointer">
          <input type="checkbox" v-model="form.show_variance_against_competition"
            name="show_variance_against_competition" class="sr-only peer">
          <div
            class="relative w-11 h-6 bg-gray-300 peer-focus:outline-none peer-focus-visible:ring-4 peer-focus-visible:ring-blue-300 dark:peer-focus-visible:ring-blue-800 rounded-full peer dark:bg-neutral-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-neutral-600 peer-checked:bg-blue-600 dark:peer-checked:bg-blue-600">
          </div>
          <span class="ms-3 text-sm font-medium">{{
            $t('fixture_lists.show_variance_against_competition.label') }}</span>
        </label>
      </div>
    </div>

    <!-- Render de tags seleccionados -->
    <div v-if="selectedFields.length > 0" class="mt-10">
      <div class="font-medium mb-2">Selected Fields</div>
      <div class="flex flex-wrap gap-2 overflow-x-auto">
        <template v-for="selectedField in selectedFields" :key="`tag-${selectedField.data_field.id}`">
          <FieldTag :selected-field="selectedField" @remove="toggleField(selectedField.data_field)" />
        </template>
      </div>
    </div>


    <div class="relative">
      <button type="submit"
        class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 focus-visible:ring-4 focus:outline-none focus-visible:ring-blue-300 dark:focus-visible:ring-blue-800 animated">
        Save
      </button>
    </div>
  </form>
</template>

<script setup>
import { initDropdowns } from 'flowbite'
import { reactive, ref, watch, defineEmits, provide, nextTick, computed, onMounted } from 'vue'
import FieldTag from './FieldTag.vue'
import Fuse from 'fuse.js'

defineOptions({ name: 'FixtureListForm' })

const props = defineProps({
  fixtureLists: Array,
  selectedFixtureList: Object,
  fixtureListMeta: Object
})

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

const selectedFields = ref([])
const selectedCompetitions = ref([])
const emit = defineEmits(['submit'])

provide('form', form)
provide('selectedFields', selectedFields)

const fieldSearch = ref('')
const competitionSearch = ref('')

// NUEVOS toggles
const showOnlySelectedFields = ref(false)
const showOnlySelectedCompetitions = ref(false)

onMounted(() => {
  initDropdowns()
})

const fieldFuse = computed(() =>
  new Fuse(props.fixtureListMeta.data_fields || [], {
    keys: ['code'],
    threshold: 0.3
  })
)

const competitionFuse = computed(() =>
  new Fuse(props.fixtureListMeta.competitions || [], {
    keys: ['name'],
    threshold: 0.3
  })
)

const filteredFields = computed(() => {
  let list = props.fixtureListMeta.data_fields || []

  if (showOnlySelectedFields.value) {
    list = list.filter(f => hasField(f.id))
  }

  if (fieldSearch.value) {
    list = fieldFuse.value.search(fieldSearch.value).map(res => res.item)
  }

  return list
})

const filteredCompetitions = computed(() => {
  let list = props.fixtureListMeta.competitions || []

  if (showOnlySelectedCompetitions.value) {
    list = list.filter(c => hasCompetition(c.id))
  }

  if (competitionSearch.value) {
    list = competitionFuse.value.search(competitionSearch.value).map(res => res.item)
  }

  return list
})

function totalSelected(arr) {
  const total = arr?.length || 0
  return total
}

function toggleField(field) {
  if (hasField(field.id)) {
    handleRemove(form.fixture_list_fields_attributes, selectedFields, 'data_field_id', field.id)
  } else {
    selectedFields.value.push({ data_field: field })
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
  const index = collection.findIndex(item => item[idKey] === compareId)
  if (index !== -1) {
    const element = collection[index]
    if (element.id) {
      element._destroy = true
    } else {
      collection.splice(index, 1)
    }
  }

  const sIndex = selectedCollection.value.findIndex(item =>
    (item.data_field?.id || item.competition?.id) === compareId
  )
  if (sIndex !== -1) selectedCollection.value.splice(sIndex, 1)
}

function hasField(id) {
  return selectedFields.value.some(f => f.data_field.id === id)
}

function hasCompetition(id) {
  return selectedCompetitions.value.some(c => c.competition.id === id)
}

watch(() => props.selectedFixtureList, (newVal) => {
  if (newVal) {
    form.name = newVal.name ?? null
    form.sample = newVal.sample ?? null
    form.home_location = newVal.home_location ?? null
    form.away_location = newVal.away_location ?? null

    selectedFields.value = (newVal.fixture_list_fields || []).map(field => ({
      id: field.id,
      data_field: field.data_field || {},
      filters: field.filters || {},
      index: field.index
    }))

    selectedCompetitions.value = (newVal.fixture_list_competitions || []).map(c => ({
      id: c.id,
      competition: c.competition || {}
    }))
  }
}, { immediate: true })

function submitForm() {
  emit('submit', form)
}

watch(selectedFields, async () => {
  await nextTick()
}, { deep: true })
</script>
