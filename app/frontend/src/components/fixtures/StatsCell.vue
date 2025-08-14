<template>
  <div class="flex gap-3 items-center px-5 border-l border-gray-200 dark:border-neutral-700">
    <div class="min-w-12">
      <div class="flex items-center h-8" :class="bestValue(homeStats?.average, awayStats?.average).class">
        {{ homeStats?.average ?? '-' }}
      </div>
      <div class="flex items-center h-8" :class="bestValue(awayStats?.average, homeStats?.average).class">
        {{ awayStats?.average ?? '-' }}
      </div>
    </div>
    <div class="min-w-12">
      <div class="flex items-center h-8">
        {{ homeStats?.overall ?? '-' }}
      </div>
      <!-- <div class="flex items-center h-8">
        {{ awayStats?.overall ?? '-' }}
      </div> -->
    </div>
    <div class="min-w-12">
      <div class="flex items-center h-8"
        :class="bestValue(homeStats?.average_by_period, awayStats?.average_by_period).class">
        {{ homeStats?.average_by_period ?? '-' }}
      </div>
      <div class="flex items-center h-8"
        :class="bestValue(awayStats?.average_by_period, homeStats?.average_by_period).class">
        {{ awayStats?.average_by_period ?? '-' }}
      </div>
    </div>
    <div class="min-w-12">
      <div class="flex items-center h-8">
        {{ homeStats?.overall_by_period ?? '-' }}
      </div>
      <!-- <div class="flex items-center h-8">
        {{ awayStats?.overall_by_period ?? '-' }}
      </div> -->
    </div>
    <div class="min-w-9">
      <div class="flex items-center h-8" :class="bestValue(homeStats?.total, awayStats?.total).class">
        {{ homeStats?.total ?? '-' }}
      </div>
      <div class="flex items-center h-8" :class="bestValue(awayStats?.total, homeStats?.total).class">
        {{ awayStats?.total ?? '-' }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { useComparison } from '@/composables/useComparison'

defineProps({
  homeStats: Object,
  awayStats: Object
})

const { bestValue } = useComparison()
</script>