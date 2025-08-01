<template>
  <td class="px-6 h-12 whitespace-nowrap">
    <div class="flex items-center gap-2">
      <span :class="bestPercentage.class">{{ teamFacts?.percentage ?? '-' }}%</span>
      <span :class="percentageDifference.class" v-if="showDifference">
        {{ percentageDifference.text }}
      </span>
    </div>
  </td>
  <td class="px-6 h-12 whitespace-nowrap">
    <span :class="bestTotal.class">{{ teamFacts?.total ?? '-' }}</span>
  </td>
  <td class="px-6 h-12 whitespace-nowrap">
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
  showDifference: Boolean
})

const { formatDifference, bestValue } = useComparison()

const percentageDifference = computed(() =>
  formatDifference(props.teamFacts?.percentage, props.competitionFacts?.percentage)
)

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