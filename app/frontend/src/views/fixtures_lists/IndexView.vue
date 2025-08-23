<template>
  <div class="flex-1 w-full my-5">
    <SearchForm 
      :fixture-lists="fixtureLists" 
      :meta-data="fixtureListMeta" 
      @search="search" 
      @getAllFixtureLists="getAllFixtureLists" 
    />
  </div>
  
  <div class="flex-1 w-full" v-if="fixtures">
    <FixturesTable 
      :fixtures="fixtures" 
      :fixture-list="fixtureList" 
      :meta-data="fixtureListMeta"
    />
  </div>
</template>

<script setup>
import { provide } from 'vue'
import FixturesTable from '@/components/fixtures/DataTable.vue'
import SearchForm from '@/components/fixture_lists/SearchForm.vue'
import { useFixtureListForm } from '@/composables/useFixtureListForm'

const { fixtureLists, fixtureListMeta, fixtures, fixtureList, form, search, getAllFixtureLists } =
  useFixtureListForm(true)

provide('form', form)
</script>
