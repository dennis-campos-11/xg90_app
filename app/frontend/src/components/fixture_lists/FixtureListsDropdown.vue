<template>
  <div class="relative">
    <button id="dropdownFixtureListsButton" data-dropdown-toggle="dropdownFixtureLists"
      data-dropdown-placement="bottom-start"
      class="w-full hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-2 py-1 text-3xl font-medium text-center flex items-center justify-between dark:hover:bg-neutral-900 dark:focus-visible:ring-neutral-600 animated"
      type="button">
      <div class="flex">
        <div v-if="selectedFixtureList">
          {{ selectedFixtureList.name }}
        </div>
        <div v-else>{{ $t("fixture_lists.select_fixture_list") }}</div>
      </div>
      <svg class="w-2.5 h-2.5 ms-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4" />
      </svg>
    </button>

    <div id="dropdownFixtureLists"
      class="w-100 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-950 dark:border-neutral-700 dark:divide-neutral-700">
      <div class="p-3">
        <div class="relative">
          <div class="absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none">
            <span class="material-symbols-outlined text-gray-400 dark:text-neutral-400">search</span>
          </div>
          <input type="text" placeholder="fields" v-model="searchQuery"
            class="block w-full p-2 ps-10 border-0 rounded-lg bg-gray-100 focus-visible:ring-blue-500 dark:bg-neutral-700 dark:placeholder-neutral-400 dark:focus-visible:ring-blue-500" />
        </div>
      </div>

      <ul class="py-3 max-h-64 overflow-y-auto" aria-labelledby="dropdownFixtureListsButton">
        <li v-for="fixtureList in filteredFixtureLists" :key="'fixture-list-' + fixtureList.id" class="cursor-pointer"
          :class="{ 'font-medium bg-gray-100 dark:bg-neutral-800': fixtureList.id === selectedFixtureList?.id }">
          <div @click="selectFixtureList(fixtureList)"
            class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-neutral-800">
            {{ fixtureList.name }}
          </div>
        </li>
        <li v-if="filteredFixtureLists.length === 0" class="px-4 py-2 text-sm text-gray-500 dark:text-neutral-500">
          {{ $t('fixture_lists.search.not_found') }}
        </li>
      </ul>

      <ul class="py-3 font-medium" aria-labelledby="dropdownFixtureListsButton">
        <li>
          <router-link to="/fixture_lists"
            class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-neutral-800 flex items-center gap-2">
            <span class="material-symbols-outlined">add</span>
            <span>{{ $t("fixture_lists.new_fixture_list") }}</span>
          </router-link>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import Fuse from 'fuse.js'

const router = useRouter()
const emit = defineEmits(['selectFixtureList'])

const props = defineProps({
  fixtureLists: Array,
  selectedFixtureList: Object
})

const searchQuery = ref('')
let fuse = null

watch(() => props.fixtureLists, (newVal) => {
  if (newVal) {
    fuse = new Fuse(newVal, {
      keys: ['name'],
      threshold: 0.3
    })
  }
}, { immediate: true })

const filteredFixtureLists = computed(() => {
  if (!searchQuery.value) return props.fixtureLists || []
  return fuse.search(searchQuery.value).map(result => result.item)
})

const selectFixtureList = (selectedFixtureList) => {
  router.push(`/fixture_lists/${selectedFixtureList.id}`)
  emit('selectFixtureList', selectedFixtureList)
}
</script>
