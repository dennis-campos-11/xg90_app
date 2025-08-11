<template>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap" v-if="isFirstRow" rowspan="2">
    <span>{{ teamFacts?.average ?? '-' }}%</span>
  </td>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap">
    <span :class="bestPercentage.class">{{ teamFacts?.percentage ?? '-' }}%</span>
  </td>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap">
    <span :class="bestTotal.class">{{ teamFacts?.total ?? '-' }}</span>
  </td>
  <td class="px-3 h-10 min-w-18 max-w-18 whitespace-nowrap">
    <span :class="bestStreak.class">{{ teamFacts?.streak ?? '-' }}</span>
  </td>
</template>

<script setup>
import { computed } from 'vue'
import { useComparison } from '@/composables/useComparison'

const props = defineProps({
  teamFacts: Object,
  opponentFacts: Object,
  competitionFacts: Object,
  isFirstRow: Boolean
})

const { bestValue } = useComparison()

const bestPercentage = computed(() =>
  bestValue(props.teamFacts?.percentage, props.opponentFacts?.percentage)
)

const bestTotal = computed(() =>
  bestValue(props.teamFacts?.total, props.opponentFacts?.total)
)

const bestStreak = computed(() =>
  bestValue(props.teamFacts?.streak, props.opponentFacts?.streak)
)

</script>