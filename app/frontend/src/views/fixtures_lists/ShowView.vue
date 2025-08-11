<template>
  <div class="flex-1 w-full my-5">
    <SearchForm :fixture-lists="fixtureLists" :fixture-list="selectedFixtureList"
      :meta-data="fixtureListMeta" @search="search" @getAllFixtureLists="getAllFixtureLists"
      @getFixtureList="getFixtureList" />
  </div>
  <div class="flex-1 w-full" v-if="fixtures">
    <FixturesTable :fixtures="fixtures" :fixture-list="fixtureList" />
  </div>
  <loadingSpinner v-else/>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import fixtureListsApi from '@/api/fixture_list'
import FixturesTable from '@/components/fixtures/DataTable.vue'
import SearchForm from '@/components/fixture_lists/SearchForm.vue'
import loadingSpinner from '@/components/loadingSpinner.vue'

const route = useRoute()
const fixtureLists = ref([])
const fixtureListMeta = ref({})
const fixtures = ref(null)
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

  fixtures.value = data?.fixtures || []
  fixtureList.value = data?.fixture_list
}

const getFixtureList = async (id) => {
  fixtures.value = null
  selectedFixtureList.value = null
  if (id === undefined) return
  const data = await fixtureListsApi.get(id)
  // fixtures.value = data?.grouped_fixtures || []
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
