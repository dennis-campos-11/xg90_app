<template>
  <div class="flex items-center border-l border-gray-200 dark:border-neutral-700">
    <div class="min-w-15 h-full flex items-center px-1.5" :class="cellFormat(homeFacts?.percentage).class">
      {{ homeFacts?.percentage ?? '-' }}%
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5"
      :class="cellFormat(awayFacts?.percentage).class">
      {{ awayFacts?.percentage ?? '-' }}%
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5">
      {{ homeFacts?.average ?? '-' }}%
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5" :class="bestValue(homeFacts?.total, awayFacts?.total).class">
      {{ homeFacts?.total ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5" :class="bestValue(awayFacts?.total, homeFacts?.total).class">
      {{ awayFacts?.total ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5" :class="bestValue(homeFacts?.streak, awayFacts?.streak).class">
      {{ homeFacts?.streak ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5" :class="bestValue(awayFacts?.streak, homeFacts?.streak).class">
      {{ awayFacts?.streak ?? '-' }}
    </div>
  </div>
</template>

<script setup>
import { useComparison } from '@/composables/useComparison'

defineProps({
  homeFacts: Object,
  awayFacts: Object
})

const { bestValue, cellFormat } = useComparison()
</script>