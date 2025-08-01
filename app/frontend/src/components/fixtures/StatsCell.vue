<template>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap">
    <span :class="bestAverage.class">{{ teamStats?.average ?? '-' }}</span>
  </td>
  <td class="px-3 h-10 min-w-24 max-w-24 whitespace-nowrap" :class="averageDifference.class" v-if="showDifference">
    {{ averageDifference.text }}
  </td>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap">
    <span :class="bestAveragePerPeriod.class">{{ teamStats?.average_by_period ?? '-' }}</span>
  </td>
  <td class="px-3 h-10 min-w-22 max-w-22 whitespace-nowrap" :class="averagePerPeriodDifference.class"
    v-if="showDifference">
    {{ averagePerPeriodDifference.text }}
  </td>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap">
    <span :class="bestTotal.class">{{ teamStats?.total ?? '-' }}</span>
  </td>
</template>

<script setup>
import { computed } from 'vue'
import { useComparison } from '@/composables/useComparison'

const props = defineProps({
  teamStats: Object,
  opponentStats: Object,
  competitionStats: Object,
  showDifference: Boolean
})

const { formatDifference, bestValue } = useComparison()

const averageDifference = computed(() =>
  formatDifference(props.teamStats?.average, props.competitionStats?.average)
)

const averagePerPeriodDifference = computed(() =>
  formatDifference(props.teamStats?.average_by_period, props.competitionStats?.average_by_period)
)

const bestAverage = computed(() =>
  bestValue(props.teamStats?.average, props.opponentStats?.average)
)

const bestAveragePerPeriod = computed(() =>
  bestValue(props.teamStats?.average_by_period, props.opponentStats?.average_by_period)
)

const bestTotal = computed(() =>
  bestValue(props.teamStats?.total, props.opponentStats?.total)
)
</script>