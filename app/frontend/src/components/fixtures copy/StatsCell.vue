<template>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap" v-if="isFirstRow" rowspan="2">
    <span>{{ teamStats?.overall ?? '-' }}</span>
  </td>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap">
    <span :class="bestAverage.class">{{ teamStats?.average ?? '-' }}</span>
  </td>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap" v-if="isFirstRow" rowspan="2">
    <span>{{ teamStats?.overall_by_period ?? '-' }}</span>
  </td>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap">
    <span :class="bestAveragePerPeriod.class">{{ teamStats?.average_by_period ?? '-' }}</span>
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
  isFirstRow: Boolean
})

const { bestValue } = useComparison()

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