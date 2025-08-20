<template>
  <div class="flex items-center border-l border-gray-200 dark:border-neutral-700">
    <div class="min-w-15 h-full flex items-center px-1.5" :class="cellFormat(homeStats?.average, homeStats?.max?.average).class">
      {{ homeStats?.average ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5" :class="cellFormat(awayStats?.average, awayStats?.max?.average).class">
      {{ awayStats?.average ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5">
      {{ homeStats?.overall ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5"
      :class="bestValue(homeStats?.average_by_period, awayStats?.average_by_period).class">
      {{ homeStats?.average_by_period ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5"
      :class="bestValue(awayStats?.average_by_period, homeStats?.average_by_period).class">
      {{ awayStats?.average_by_period ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5">
      {{ homeStats?.overall_by_period ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5" :class="bestValue(homeStats?.total, awayStats?.total).class">
      {{ homeStats?.total ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5" :class="bestValue(awayStats?.total, homeStats?.total).class">
      {{ awayStats?.total ?? '-' }}
    </div>
  </div>
</template>

<script setup>
import { useComparison } from '@/composables/useComparison'

defineProps({
  homeStats: Object,
  awayStats: Object
})

const { bestValue, cellFormat } = useComparison()
</script>