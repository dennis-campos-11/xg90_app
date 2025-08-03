<template>
  <div class="w-full">
    <table class="w-full table-auto border-collapse text-left" v-if="groupedFixtures.length">
      <thead class="sticky top-0 bg-white z-30">
        <TableHead :fields="fixtureList.fixture_list_fields" :hasScrolled="hasScrolled" />
      </thead>
      <tbody>
        <template v-for="group in groupedFixtures" :key="`group-${group.competition.id}`">
          <CompetitionRow :competition="group.competition" :hasScrolled="hasScrolled" />
          <template v-for="(fixture, index) in group.fixtures" :key="`fixture-${fixture.id}`">
            <TeamRow :competition="group.competition" :fixture="fixture" :index="index" :team="fixture.home"
              team-type="home" opponent-type="away" :fields="fixtureList.fixture_list_fields"
              :has-scrolled="hasScrolled" :is-first-column="true" :is-last-column="false" :hovered-index="hoveredIndex"
              :show-difference="showDifference" @hover="handleHover" />
            <TeamRow :competition="group.competition" :fixture="fixture" :index="index" :team="fixture.away"
              team-type="away" opponent-type="home" :fields="fixtureList.fixture_list_fields"
              :has-scrolled="hasScrolled" :is-first-column="false" :is-last-column="true" :hovered-index="hoveredIndex"
              :show-difference="showDifference" @hover="handleHover" />
          </template>
        </template>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import CompetitionRow from './CompetitionRow.vue'
import TeamRow from './TeamRow.vue'
import TableHead from './TableHead.vue'

const hoveredIndex = ref(null)

defineProps({
  fixtureList: Object,
  groupedFixtures: Array,
  showDifference: Boolean,
  hasScrolled: Boolean
})

const handleHover = (index) => {
  hoveredIndex.value = index
}
</script>
