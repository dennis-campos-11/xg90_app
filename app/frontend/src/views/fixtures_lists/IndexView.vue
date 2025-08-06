<template>
  <div class="flex-1 w-full my-5">
    <SearchForm :fixture-lists="fixtureLists" :meta-data="fixtureListMeta" @search="search"
      @getAllFixtureLists="getAllFixtureLists" />
  </div>
  <div class="flex-1 w-full">
    <FixturesTable :grouped-fixtures="groupedFixtures" :fixture-list="fixtureList" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import fixtureListsApi from '@/api/fixture_list'
import FixturesTable from '@/components/fixtures/DataTable.vue'
import SearchForm from '@/components/fixture_lists/SearchForm.vue'

const fixtureLists = ref([])
const fixtureListMeta = ref({})
const groupedFixtures = ref([])
const fixtureList = ref(null)

onMounted(() => {
  getAllFixtureLists()
  getFixtureListMeta()
})

const search = async (params = {}) => {
  const data = await fixtureListsApi.search({ fixture_list: params })
  groupedFixtures.value = data?.grouped_fixtures || []
  fixtureList.value = data?.fixture_list
}

const getAllFixtureLists = async () => {
  const data = await fixtureListsApi.getAll()
  fixtureLists.value = data
}

const getFixtureListMeta = async () => {
  const data = await fixtureListsApi.meta()
  fixtureListMeta.value = data
}
</script>
