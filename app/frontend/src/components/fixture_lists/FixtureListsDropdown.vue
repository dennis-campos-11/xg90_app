<template>
  <div class="relative">
    <button
      id="dropdownFixtureListsButton"
      data-dropdown-toggle="dropdownFixtureLists"
      data-dropdown-placement="bottom-start"
      class="w-full hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg p-2 text-3xl font-medium text-center flex items-center justify-between dark:hover:bg-neutral-900 dark:focus-visible:ring-neutral-600 animated"
      type="button"
    >
      <div class="flex">
        <div v-if="selectedFixtureList">
          {{ selectedFixtureList.name }}
        </div>
        <div v-else>{{ $t("fixture_lists.select_fixture_list") }}</div>
      </div>
      <svg
        class="w-2.5 h-2.5 ms-3"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 10 6"
      >
        <path
          stroke="currentColor"
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="m1 1 4 4 4-4"
        />
      </svg>
    </button>

    <div
      id="dropdownFixtureLists"
      class="w-100 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 dark:divide-neutral-800"
    >
      <!-- Crear nueva lista -->
      <ul class="py-3 font-medium" aria-labelledby="dropdownFixtureListsButton">
        <li>
          <router-link
            to="/fixture_lists"
            class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-neutral-800 flex items-center gap-2"
          >
            <span class="material-symbols-outlined">add</span>
            <span>{{ $t("fixture_lists.new_fixture_list") }}</span>
          </router-link>
        </li>
      </ul>

      <!-- Listado de fixture lists -->
      <ul class="py-3 font-medium" aria-labelledby="dropdownFixtureListsButton">
        <li
          v-for="fixtureList in fixtureLists"
          :key="'fixture-list-' + fixtureList.id"
        >
          <div
            @click="selectFixtureList(fixtureList)"
            class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-neutral-800"
          >
            {{ fixtureList.name }}
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
const router = useRouter()
const emit = defineEmits(['selectFixtureList'])

defineProps({
  fixtureLists: Array,
  selectedFixtureList: Object
})

const selectFixtureList = (fixtureList) => {
  router.push(`/fixture_lists/${fixtureList.id}`)
  emit('selectFixtureList', fixtureList)
}
</script>
