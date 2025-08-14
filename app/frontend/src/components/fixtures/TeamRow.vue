<template>
  <div class="flex min-w-max bg-inherit">
    <div class="min-w-22 max-w-22 px-3 text-center flex items-center text-center">
      <div class="w-full">
        <div class="mb-1">{{ fixture.kick_off }}</div>
        <img :src="getCompetitionLogo(fixture.competition.id)" class="block mx-auto w-7 h-7" />
      </div>
    </div>

    <div class="min-w-50 max-w-50 px-3 !border-b-0 font-medium whitespace-nowrap sticky left-0 z-10 bg-inherit"
      :class="{ 'border-r border-gray-200 dark:border-neutral-700': hasScrolled }">
      <div class="flex items-center h-8">
        <img :src="getTeamLogo(fixture.home.id)" class="inline w-7 h-7 mr-2" />
        <div class="truncate" :title="fixture.home.name">{{ fixture.home.name }}</div>
      </div>
      <div class="flex items-center h-8">
        <img :src="getTeamLogo(fixture.away.id)" class="inline w-7 h-7 mr-2" />
        <div class="truncate" :title="fixture.away.name">{{ fixture.away.name }}</div>
      </div>
    </div>

    <template v-for="field in fields" :key="`${fixture.id}-${field.data_field.id}`">
      <StatsCell v-if="field.data_field.field_type === 'statistic'"
        :home-stats="fixture.home_processed_stats?.[field.data_field.code]"
        :away-stats="fixture.away_processed_stats?.[field.data_field.code]" />
      <FactsCell v-else-if="field.data_field.field_type === 'fact'"
        :home-facts="fixture.home_processed_facts?.[field.data_field.code]"
        :away-facts="fixture.away_processed_facts?.[field.data_field.code]" />
    </template>
  </div>
</template>

<script setup>
import StatsCell from './StatsCell.vue'
import FactsCell from './FactsCell.vue'

defineProps({
  fixture: Object,
  fields: Array,
  hasScrolled: Boolean
})

function getTeamLogo(teamId) {
  return `http://localhost:3000/laliga/${teamId}.png` // ajusta según tu estructura real
}

function getCompetitionLogo(competitionId) {
  return `http://localhost:3000/competitions/${competitionId}.png` // ajusta según tu estructura real
}
</script>