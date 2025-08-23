<template>
  <div class="flex items-center border-l border-gray-200 dark:border-neutral-700">
    <div class="min-w-15 h-full flex items-center px-1.5" 
      :class="{
        [cellFormat(homeFacts?.percentage).class]: form.settings.general.highlight_cells
      }"
    >
      {{ homeFacts?.percentage ?? '-' }}%
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5"
      :class="{
        [cellFormat(awayFacts?.percentage).class]: form.settings.general.highlight_cells
      }"
    >
      {{ awayFacts?.percentage ?? '-' }}%
    </div>
    <template v-if="form.settings?.facts?.show_percentage_average">
      <div class="min-w-15 h-full flex items-center px-1.5">
        {{ homeFacts?.average ?? '-' }}%
      </div>
    </template>
    <template v-if="form.settings?.facts?.show_totals">
      <div class="min-w-15 h-full flex items-center px-1.5" 
        :class="bestValue(homeFacts?.total, awayFacts?.total).class">
        {{ homeFacts?.total ?? '-' }}
      </div>
      <div class="min-w-15 h-full flex items-center px-1.5" 
        :class="bestValue(awayFacts?.total, homeFacts?.total).class">
        {{ awayFacts?.total ?? '-' }}
      </div>
    </template>
    <div class="min-w-15 h-full flex items-center px-1.5" 
      :class="bestValue(homeFacts?.streak, awayFacts?.streak).class">
      {{ homeFacts?.streak ?? '-' }}
    </div>
    <div class="min-w-15 h-full flex items-center px-1.5" 
      :class="bestValue(awayFacts?.streak, homeFacts?.streak).class">
      {{ awayFacts?.streak ?? '-' }}
    </div>
  </div>
</template>

<script setup>
import { inject } from 'vue'
import { useComparison } from '@/composables/useComparison'

defineProps({
  homeFacts: Object,
  awayFacts: Object
})

const form = inject('form')

const { bestValue, cellFormat } = useComparison()
</script>