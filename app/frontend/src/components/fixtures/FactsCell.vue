<template>
  <div class="flex gap-3 items-center px-5 border-l border-gray-200 dark:border-neutral-700">
    <div class="min-w-12">
      <div class="flex items-center h-8" :class="bestValue(homeFacts?.percentage, awayFacts?.percentage).class">
        {{ homeFacts?.percentage ?? '-' }}%
      </div>
      <div class="flex items-center h-8" :class="bestValue(awayFacts?.percentage, homeFacts?.percentage).class">
        {{ awayFacts?.percentage ?? '-' }}%
      </div>
    </div>
    <div class="min-w-14">
      <div class="flex items-center h-8">
        {{ homeFacts?.average ?? '-' }}%
      </div>
      <!-- <div class="flex items-center h-8">
        {{ awayFacts?.average ?? '-' }}%
      </div> -->
    </div>
    <div class="min-w-9">
      <div class="flex items-center h-8" :class="bestValue(homeFacts?.total, awayFacts?.total).class">
        {{ homeFacts?.total ?? '-' }}
      </div>
      <div class="flex items-center h-8" :class="bestValue(awayFacts?.total, homeFacts?.total).class">
        {{ awayFacts?.total ?? '-' }}
      </div>
    </div>
    <div class="min-w-9">
      <div class="flex items-center h-8" :class="bestValue(homeFacts?.streak, awayFacts?.streak).class">
        {{ homeFacts?.streak ?? '-' }}
      </div>
      <div class="flex items-center h-8" :class="bestValue(awayFacts?.streak, homeFacts?.streak).class">
        {{ awayFacts?.streak ?? '-' }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { useComparison } from '@/composables/useComparison'

defineProps({
  homeFacts: Object,
  awayFacts: Object
})

const { bestValue } = useComparison()
</script>