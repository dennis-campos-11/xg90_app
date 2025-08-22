<template>
  <div v-if="props.metaData" class="grid grid-cols-5 gap-3">
    <div class="relative">
      <button id="home-location-button" data-dropdown-toggle="home-location-dropdown"
        data-dropdown-placement="bottom-start"
        class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-3 py-1.5 text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-700 animated"
        type="button">
        <div class="flex gap-2">
          <div>{{ $t('fixture_lists.home_location.label') }}</div>
          <div v-if="form.home_location" class="font-medium">{{
            $t(`fixture_lists.home_location.values.${form.home_location}`) }}</div>
        </div>
        <span class="material-symbols-outlined">keyboard_arrow_down</span>
      </button>
      <div id="home-location-dropdown"
        class="w-55 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg dark:bg-neutral-950 dark:border-neutral-700 dark:divide-neutral-700">
        <ul class="p-3" aria-labelledby="home-location-button">
          <li v-for="homeLocation in metaData.home_locations" :key="`home-location-${homeLocation.id}`" class="group">
            <div class="flex items-center">
              <input type="radio" :id="`home-location-${homeLocation.id}`" :value="homeLocation.id"
                :name="`home-location-${homeLocation.id}`" v-model="form.home_location" class="hidden peer">
              <label :for="`home-location-${homeLocation.id}`"
                class="inline-flex items-center justify-between w-full px-3 h-9 rounded-md cursor-pointer hover:bg-gray-100 peer-checked:font-medium dark:hover:bg-neutral-900">
                {{ $t(`fixture_lists.home_location.values.${homeLocation.id}`) }}
                <span class="material-symbols-outlined !hidden text-green-500 group-has-checked:!inline-block">
                  check
                </span>
              </label>
            </div>
          </li>
        </ul>
      </div>
    </div>

    <div class="relative">
      <button id="away-location-button" data-dropdown-toggle="away-location-dropdown"
        data-dropdown-placement="bottom-start"
        class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-3 py-1.5 text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-700 animated"
        type="button">
        <div class="flex gap-2">
          <div>{{ $t('fixture_lists.away_location.label') }}</div>
          <div v-if="form.away_location" class="font-medium">{{
            $t(`fixture_lists.away_location.values.${form.away_location}`) }}</div>
        </div>
        <span class="material-symbols-outlined">keyboard_arrow_down</span>
      </button>
      <div id="away-location-dropdown"
        class="w-55 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg dark:bg-neutral-950 dark:border-neutral-700 dark:divide-neutral-700">
        <ul class="p-3" aria-labelledby="away-location-button">
          <li v-for="awayLocation in metaData.home_locations" :key="`away-location-${awayLocation.id}`" class="group">
            <div class="flex items-center">
              <input type="radio" :id="`away-location-${awayLocation.id}`" :value="awayLocation.id"
                :name="`away-location-${awayLocation.id}`" v-model="form.away_location" class="hidden peer">
              <label :for="`away-location-${awayLocation.id}`"
                class="inline-flex items-center justify-between w-full px-3 h-9 rounded-md cursor-pointer hover:bg-gray-100 peer-checked:font-medium dark:hover:bg-neutral-900">
                {{ $t(`fixture_lists.away_location.values.${awayLocation.id}`) }}
                <span class="material-symbols-outlined !hidden text-green-500 group-has-checked:!inline-block">
                  check
                </span>
              </label>
            </div>
          </li>
        </ul>
      </div>
    </div>

    <div class="relative">
      <button id="total-matches-button" data-dropdown-toggle="total-matches-dropdown"
        data-dropdown-placement="bottom-start"
        class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-3 py-1.5 text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-700 animated"
        type="button">
        <div class="flex gap-2">
          <div>{{ $t('fixture_lists.total_matches.label') }}</div>
          <div class="font-medium">{{ form.total_matches }}</div>
        </div>
        <span class="material-symbols-outlined">keyboard_arrow_down</span>
      </button>
      <div id="total-matches-dropdown"
        class="w-full z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg dark:bg-neutral-950 dark:border-neutral-700 dark:divide-neutral-700">
        <div class="p-3" v-if="form.total_matches !== null">
          <Slider 
            v-model="form.total_matches"
            :min="0"
            :max="150"
            show-tooltip="drag"
            tooltip-position="bottom" class="
              [--slider-connect-bg:#155dfc]
              [--slider-connect-bg-hover:#2563eb]
              [--slider-rail-bg:#bfdbfe]
              [--slider-thumb-bg:#155dfc]
              [--slider-thumb-bg-hover:#2563eb]
              [--slider-thumb-border:#155dfc]
              [--slider-handle-shadow:0_0_0_3px_#155dfc]
              [--slider-tooltip-bg:#155dfc]
              [--slider-tooltip-color:white]
            " />
        </div>
      </div>
    </div>

    <div class="relative">
      <button id="season-index-button" data-dropdown-toggle="season-index-dropdown"
        data-dropdown-placement="bottom-start"
        class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-3 py-1.5 text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-700 animated"
        type="button">
        <div class="flex gap-2">
          <div>{{ $t('fixture_lists.season_index.label') }}</div>
          <div class="font-medium">{{ $t(`fixture_lists.season_index.values.${form.season_index}`) }}</div>
        </div>
        <span class="material-symbols-outlined">keyboard_arrow_down</span>
      </button>
      <div id="season-index-dropdown"
        class="w-55 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg dark:bg-neutral-950 dark:border-neutral-700 dark:divide-neutral-700">
        <ul class="p-3" aria-labelledby="season-index-button">
          <li v-for="season in metaData?.season_indexes" :key="`season-index-${season.id}`" class="group">
            <div class="flex items-center">
              <input type="radio" :id="`season-index-${season.id}`" :value="season.id"
                :name="`season-index-${season.id}`" v-model="form.season_index" class="hidden peer">
              <label :for="`season-index-${season.id}`"
                class="inline-flex items-center justify-between w-full px-3 h-9 rounded-md cursor-pointer hover:bg-gray-100 peer-checked:font-medium dark:hover:bg-neutral-900">
                {{ season.value }}
                <span class="material-symbols-outlined !hidden text-green-500 group-has-checked:!inline-block">
                  check
                </span>
              </label>
            </div>
          </li>
        </ul>
      </div>
    </div>

    <div class="relative">
      <button id="fields-button" data-dropdown-toggle="fields-dropdown" data-dropdown-placement="bottom-start"
        class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-3 py-1.5 text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-700 animated"
        type="button">
        <div class="flex gap-2">
          <div>{{ $t('fixture_lists.fields.label') }}</div>
          <div class="font-medium">{{ $t('fixture_lists.fields.total', { total: availableFields?.length }) }}</div>
        </div>
        <span class="material-symbols-outlined">keyboard_arrow_down</span>
      </button>
      <div id="fields-dropdown"
        class="w-80 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-950 dark:border-neutral-700 dark:divide-neutral-700">
        <div class="p-3">
          <div class="relative">
            <div class="absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none">
              <span class="material-symbols-outlined text-gray-400 dark:text-neutral-400">search</span>
            </div>
            <input type="text" placeholder="fields" v-model="fieldSearch"
              class="text-sm block w-full p-2 ps-10 border-0 rounded-lg bg-gray-100 focus-visible:ring-blue-500 dark:bg-neutral-700 dark:placeholder-neutral-400 dark:focus-visible:ring-blue-500" />
          </div>
        </div>
        <ul class="h-48 p-3 overflow-y-auto">
          <li v-for="dataField in filteredFields" :key="`data-field-${dataField.id}`" class="group">
            <div class="flex items-center">
              <input type="checkbox" :id="`data-field-${dataField.id}`" :value="dataField.id"
                :name="`data-field-${dataField.id}`" :checked="hasField(dataField.id)" @change="toggleField(dataField)"
                class="hidden peer">
              <label :for="`data-field-${dataField.id}`"
                class="inline-flex items-center justify-between w-full px-3 h-9 rounded-md cursor-pointer hover:bg-gray-100 peer-checked:font-medium dark:hover:bg-neutral-900">
                {{ $t(`data_fields.${dataField.code}`) }}
                <span class="material-symbols-outlined !hidden text-green-500 group-has-checked:!inline-block">
                  check
                </span>
              </label>
            </div>
          </li>
          <li v-if="filteredFields.length === 0" class="px-4 py-2 text-sm text-gray-500 dark:text-neutral-500">
            {{ $t('fixture_lists.fields.not_found') }}
          </li>
        </ul>
        <div class="flex items-center p-3 rounded-b-lg bg-gray-100 dark:bg-white/5">
          <label class="inline-flex items-center cursor-pointer">
            <input type="checkbox" class="sr-only peer" v-model="showOnlySelectedFields" />
            <div
              class="relative w-9 h-5 bg-gray-300 rounded-full peer dark:bg-neutral-700 peer-checked:bg-blue-600 after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border after:border-neutral-300 peer-checked:after:border-blue-700 after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:after:translate-x-full">
            </div>
            <span class="ms-3 font-medium">{{ $t('miscellaneous.show_only_selected') }}</span>
          </label>
        </div>
      </div>
    </div>

    <div class="relative">
      <button id="competitions-button" data-dropdown-toggle="competitions-dropdown"
        data-dropdown-placement="bottom-start"
        class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-3 py-1.5 text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-700 animated"
        type="button">
        <div class="flex gap-2">
          <div>{{ $t('fixture_lists.competitions.label') }}</div>
          <div class="font-medium">{{ $t('fixture_lists.competitions.total', { total: availableCompetitions?.length })
          }}</div>
        </div>
        <span class="material-symbols-outlined">keyboard_arrow_down</span>
      </button>
      <div id="competitions-dropdown"
        class="w-80 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-950 dark:border-neutral-700 dark:divide-neutral-700">
        <div class="p-3">
          <div class="relative">
            <div class="absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none">
              <span class="material-symbols-outlined text-gray-400 dark:text-neutral-400">search</span>
            </div>
            <input type="text" placeholder="competitions" v-model="competitionSearch"
              class="text-sm block w-full p-2 ps-10 border-0 rounded-lg bg-gray-100 focus-visible:ring-blue-500 dark:bg-neutral-700 dark:placeholder-neutral-400 dark:focus-visible:ring-blue-500" />
          </div>
        </div>
        <ul class="h-48 p-3 overflow-y-auto">
          <li v-for="competition in filteredCompetitions" :key="`competition-${competition.id}`" class="group">
            <div class="flex items-center">
              <input type="checkbox" :id="`competition-${competition.id}`" :value="competition.id"
                :name="`competition-${competition.id}`" :checked="hasCompetition(competition.id)"
                @change="toggleCompetition(competition)" class="hidden peer">
              <label :for="`competition-${competition.id}`"
                class="inline-flex items-center justify-between w-full px-3 h-9 rounded-md cursor-pointer hover:bg-gray-100 peer-checked:font-medium dark:hover:bg-neutral-900">
                {{ competition.name }}
                <span class="material-symbols-outlined !hidden text-green-500 group-has-checked:!inline-block">
                  check
                </span>
              </label>
            </div>
          </li>
          <li v-if="filteredCompetitions.length === 0" class="px-4 py-2 text-sm text-gray-500 dark:text-neutral-500">
            {{ $t('fixture_lists.competitions.not_found') }}
          </li>
        </ul>
        <div class="flex items-center p-3 rounded-b-lg bg-gray-100 dark:bg-white/5">
          <label class="inline-flex items-center cursor-pointer">
            <input type="checkbox" class="sr-only peer" v-model="showOnlySelectedCompetitions" />
            <div
              class="relative w-9 h-5 bg-gray-300 rounded-full peer dark:bg-neutral-700 peer-checked:bg-blue-600 after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border after:border-neutral-300 peer-checked:after:border-blue-700 after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:after:translate-x-full">
            </div>
            <span class="ms-3 font-medium">{{ $t('miscellaneous.show_only_selected') }}</span>
          </label>
        </div>
      </div>
    </div>

    <div class="relative flex items-center">
      <label class="inline-flex items-center cursor-pointer">
        <input type="checkbox" v-model="form.only_current_competition" class="sr-only peer" />
        <div
          class="relative w-11 h-6 bg-gray-300 rounded-full peer dark:bg-neutral-700 peer-checked:bg-blue-600 after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border after:border-neutral-300 peer-checked:after:border-blue-700 after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-full">
        </div>
        <span class="ms-3">{{ $t('fixture_lists.only_current_competition.label') }}</span>
      </label>
    </div>
  </div>
</template>
<script setup>
import { inject, onMounted } from 'vue'
import { useFixtureList } from '@/composables/useFixtureList'
import { initDropdowns } from 'flowbite'
import Slider from "@vueform/slider"

const props = defineProps({ metaData: Object })
const form = inject('form')

onMounted(() => {
  initDropdowns()
})

const {
  search: fieldSearch,
  showOnlySelected: showOnlySelectedFields,
  filteredItems: filteredFields,
  hasItem: hasField,
  toggleItem: toggleField,
  availableItems: availableFields,
} = useFixtureList(form, props, 'fixture_list_fields_attributes', 'data_field', ['code'])

const {
  search: competitionSearch,
  showOnlySelected: showOnlySelectedCompetitions,
  filteredItems: filteredCompetitions,
  hasItem: hasCompetition,
  toggleItem: toggleCompetition,
  availableItems: availableCompetitions,
} = useFixtureList(form, props, 'fixture_list_competitions_attributes', 'competition', ['name'])
</script>
