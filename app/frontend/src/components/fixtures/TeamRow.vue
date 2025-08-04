<template>
  <!-- eslint-disable vue/no-v-for-template-key -->
  <tr @mouseenter="onMouseEnter(index)" @mouseleave="onMouseLeave" :class="[
    { 'bg-gray-100 dark:bg-neutral-900': (hoveredIndex === index) },
    { 'bg-white dark:bg-black': (hoveredIndex !== index) },
    { 'border-b-1 border-gray-200 dark:border-neutral-800': isLastColumn }
  ]">
    <td v-if="isFirstColumn" class="px-3 min-w-22 max-w-22 whitespace-nowrap text-center align-middle" :rowspan="2">
      <div class="mb-1">{{ fixture.kick_off }}</div>
      <img :src="getCompetitionLogo(competition.id)" class="block mx-auto w-7 h-7" />
    </td>

    <td class="px-3 min-w-50 max-w-50 font-medium whitespace-nowrap sticky left-0 z-10 bg-inherit"
      :class="{ 'right-shadow': hasScrolled }">
      <div class="flex items-center w-45">
        <img :src="getTeamLogo(team.id)" class="inline w-7 h-7 mr-2" />
        <div class="truncate" :title="team.name">{{ team.name }}</div>
      </div>
    </td>

    <template v-for="field in fields" :key="`${teamType}-${fixture.id}-${field.data_field.id}`">
      <StatsCell v-if="field.data_field.field_type === 'statistic'" :team-stats="teamStats?.[field.data_field.code]"
        :opponent-stats="opponentStats?.[field.data_field.code]"
        :competition-stats="competitionStats?.[field.data_field.code]" :show-difference="showDifference" />
      <FactsCell v-else-if="field.data_field.field_type === 'fact'" :team-facts="teamFacts?.[field.data_field.code]"
        :opponent-facts="opponentFacts?.[field.data_field.code]"
        :competition-facts="competitionFacts?.[field.data_field.code]" :show-difference="showDifference" />
    </template>
  </tr>
</template>

<script setup>
import { computed } from 'vue'
import StatsCell from './StatsCell.vue'
import FactsCell from './FactsCell.vue'

const props = defineProps({
  competition: Object,
  fixture: Object,
  index: Number,
  team: Object,
  teamType: String,
  opponentType: String,
  fields: Array,
  hasScrolled: Boolean,
  isFirstColumn: Boolean,
  isLastColumn: Boolean,
  hoveredIndex: Number,
  showDifference: Boolean
})

const teamStats = computed(() => props.fixture[`${props.teamType}_processed_stats`])
const opponentStats = computed(() => props.fixture[`${props.opponentType}_processed_stats`])
const competitionStats = computed(() => props.competition.grouped_processed_stats[`${props.teamType}`])
const teamFacts = computed(() => props.fixture[`${props.teamType}_processed_facts`])
const opponentFacts = computed(() => props.fixture[`${props.opponentType}_processed_facts`])
const competitionFacts = computed(() => props.competition.grouped_processed_facts[`${props.teamType}`])

const emit = defineEmits(['hover'])

const onMouseEnter = (index) => {
  emit('hover', index)
}

const onMouseLeave = () => {
  emit('hover', null)
}

function getTeamLogo(teamId) {
  return `http://localhost:3000/laliga/${teamId}.png` // ajusta según tu estructura real
}

function getCompetitionLogo(competitionId) {
  return `http://localhost:3000/competitions/${competitionId}.png` // ajusta según tu estructura real
}
</script>