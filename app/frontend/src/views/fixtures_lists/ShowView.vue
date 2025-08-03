<template>
  <div class="flex-1 w-full my-5">
    <FixtureListFilterForm :fixture-lists="fixtureLists" :fixture-list="selectedFixtureList"
      :fixture-list-meta="fixtureListMeta" @search="search" @getAllFixtureLists="getAllFixtureLists"
      @getFixtureList="getFixtureList" />
  </div>
  <div class="flex-1 w-full">
    <FixturesTable :grouped-fixtures="groupedFixtures" :fixture-list="fixtureList" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import fixtureListsApi from '@/api/fixture_list'
import FixturesTable from '@/components/fixtures/DataTable.vue'
import FixtureListFilterForm from '@/components/fixture_lists/FilterForm.vue'

const route = useRoute()
const fixtureLists = ref([])
const fixtureListMeta = ref({})
const groupedFixtures = ref([])
const fixtureList = ref(null)
const selectedFixtureList = ref(null)

onMounted(() => {
  const id = route.params.id

  getAllFixtureLists()
  getFixtureList(id)
  getFixtureListMeta()
})

const search = async (params = {}) => {
  const data = await fixtureListsApi.search({ fixture_list: params })
  groupedFixtures.value = data?.grouped_fixtures || []
  fixtureList.value = data?.fixture_list
}

const getFixtureList = async (id) => {
  if (id === undefined) return
  const data = await fixtureListsApi.get(id)
  groupedFixtures.value = data?.grouped_fixtures || []
  selectedFixtureList.value = data?.fixture_list
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
