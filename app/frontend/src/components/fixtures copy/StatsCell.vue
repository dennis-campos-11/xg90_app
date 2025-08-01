<template>
  <td class="px-6 h-12 whitespace-nowrap">
    <div class="flex items-center gap-2">
      <span :class="bestAverage.class">{{ teamStats?.average ?? '-' }}</span>
      <span :class="averageDifference.class" v-if="showDifference">
        {{ averageDifference.text }}
      </span>
    </div>
  </td>
  <td class="px-6 h-12 whitespace-nowrap">
    <div class="flex items-center gap-2">
      <span :class="bestAveragePerPeriod.class">{{ teamStats?.average_by_period ?? '-' }}</span>
      <span :class="averagePerPeriodDifference.class" v-if="showDifference">
        {{ averagePerPeriodDifference.text }}
      </span>
    </div>
  </td>
  <td class="px-6 h-12 whitespace-nowrap">
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