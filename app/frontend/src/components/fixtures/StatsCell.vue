<template>
  <div class="flex items-center border-l border-gray-200 dark:border-neutral-700">
    <div class="min-w-15 h-full flex items-center px-1.5" 
      :class="{
        [cellFormat(homeStats?.average, homeStats?.max?.average).class]: form.settings.general.highlight_cells
      }"
    >
      {{ homeStats?.average ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5" 
      :class="{
        [cellFormat(awayStats?.average, awayStats?.max?.average).class]: form.settings.general.highlight_cells
      }"
    >
      {{ awayStats?.average ?? '-' }}
    </div>
    <template v-if="form.settings?.statistics?.show_total_average">
      <div class="min-w-15 h-full flex items-center px-1.5">
        {{ homeStats?.overall ?? '-' }}
      </div>
    </template>
    <div class="min-w-15 h-full flex items-center px-1.5"
      :class="bestValue(homeStats?.average_by_period, awayStats?.average_by_period).class">
      {{ homeStats?.average_by_period ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5"
      :class="bestValue(awayStats?.average_by_period, homeStats?.average_by_period).class">
      {{ awayStats?.average_by_period ?? '-' }}
    </div>
    <template v-if="form.settings?.statistics?.show_total_average_per_period">
      <div class="min-w-15 h-full flex items-center px-1.5">
        {{ homeStats?.overall_by_period ?? '-' }}
      </div>
    </template>
    <template v-if="form.settings?.statistics?.show_totals">
      <div class="min-w-15 h-full flex items-center px-1.5" 
        :class="bestValue(homeStats?.total, awayStats?.total).class">
        {{ homeStats?.total ?? '-' }}
      </div>
      <div class="min-w-15 h-full flex items-center px-1.5" 
        :class="bestValue(awayStats?.total, homeStats?.total).class">
        {{ awayStats?.total ?? '-' }}
      </div>
    </template>
  </div>
</template>

<script setup>
import { inject } from 'vue'
import { useComparison } from '@/composables/useComparison'

defineProps({
  homeStats: Object,
  awayStats: Object
})

const form = inject('form')

const { bestValue, cellFormat } = useComparison()
</script>