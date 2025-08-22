<template>
  <div class="flex min-w-max bg-inherit h-10">
    <div class="min-w-15 max-w-15 px-1.5 flex items-center">
      {{ fixture.kick_off }}
    </div>

    <div class="px-1.5 font-medium whitespace-nowrap sticky left-0 z-10 bg-inherit animated"
      :class="[
        hasScrolled ? 'right-shadow min-w-44 max-w-44' : 'min-w-80 max-w-80'
      ]"
    >
      <div class="flex items-center w-full h-full">
        <img :src="getTeamLogo(fixture.home.id)" class="flex-none w-7 h-7" />
        <img :src="getTeamLogo(fixture.away.id)" class="flex-none w-7 h-7" />
        <div class="grow font-semibold truncate ml-2" :title="`${fixture.home.name} vs ${fixture.away.name}`">
          <div v-if="hasScrolled" class="flex w-full gap-1">
            {{ fixture.home.short_name }} VS {{ fixture.away.short_name }}
          </div>
          <div v-else>
            {{ fixture.home.name }} vs {{ fixture.away.name }}
          </div>
        </div>
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

// function getCompetitionLogo(competitionId) {
//   return `http://localhost:3000/competitions/${competitionId}.png` // ajusta según tu estructura real
// }
</script>