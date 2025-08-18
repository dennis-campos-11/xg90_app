<template>
  <div class="flex items-center text-right border-l border-gray-200 dark:border-neutral-700">
    <div class="min-w-16">
      <div class="flex items-center h-8 px-2" :class="cellFormat(homeFacts?.percentage).class">
        {{ homeFacts?.percentage ?? '-' }}%
      </div>
      <div class="flex items-center h-8 px-2"
        :class="cellFormat(awayFacts?.percentage).class">
        {{ awayFacts?.percentage ?? '-' }}%
      </div>
    </div>
    <div class="min-w-16">
      <div class="flex items-center h-8 px-2">
        {{ homeFacts?.average ?? '-' }}%
      </div>
      <!-- <div class="flex items-center h-8 px-2">
        {{ awayFacts?.average ?? '-' }}%
      </div> -->
    </div>
    <div class="min-w-16">
      <div class="flex items-center h-8 px-2" :class="bestValue(homeFacts?.total, awayFacts?.total).class">
        {{ homeFacts?.total ?? '-' }}
      </div>
      <div class="flex items-center h-8 px-2" :class="bestValue(awayFacts?.total, homeFacts?.total).class">
        {{ awayFacts?.total ?? '-' }}
      </div>
    </div>
    <div class="min-w-16">
      <div class="flex items-center h-8 px-2" :class="bestValue(homeFacts?.streak, awayFacts?.streak).class">
        {{ homeFacts?.streak ?? '-' }}
      </div>
      <div class="flex items-center h-8 px-2" :class="bestValue(awayFacts?.streak, homeFacts?.streak).class">
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

const { bestValue, cellFormat } = useComparison()
</script>