<template>
  <div class="flex-1 w-full my-5">
    <SearchForm 
      :fixture-lists="fixtureLists" 
      :fixture-list="selectedFixtureList"
      :meta-data="fixtureListMeta" 
      @search="search" 
      @getAllFixtureLists="getAllFixtureLists"
      @getFixtureList="getFixtureList" 
    />
  </div>

  <div class="flex-1 w-full" v-if="fixtures">
    <FixturesTable :fixtures="fixtures" :fixture-list="fixtureList" />
  </div>
  <loadingSpinner v-else/>
</template>

<script setup>
import { provide } from 'vue'
import FixturesTable from '@/components/fixtures/DataTable.vue'
import SearchForm from '@/components/fixture_lists/SearchForm.vue'
import loadingSpinner from '@/components/loadingSpinner.vue'
import { useFixtureListForm } from '@/composables/useFixtureListForm'

const { fixtureLists, fixtureListMeta, fixtures, fixtureList, selectedFixtureList, form, search, getFixtureList, getAllFixtureLists } =
  useFixtureListForm(true)

provide('form', form)
</script>
