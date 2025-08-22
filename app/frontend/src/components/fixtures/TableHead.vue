<template>
  <div class="flex min-w-max bg-inherit">
    <!-- Kick Off -->
    <div class="min-w-15 max-w-15 flex items-end">
      <div 
        :key="kickOffColumn.label"
        class="relative p-1.5 text-xs uppercase leading-tight font-medium"
        :class="getSortCellClass('kick_off', kickOffColumn)"
        @click="toggleSort('kick_off', kickOffColumn)"
      >
        {{ $t(kickOffColumn.label) }}
        <span
          class="material-symbols-outlined !font-bold !text-base absolute top-0 right-0"
        >
          {{ getSortIcon('kick_off', kickOffColumn) }}
        </span>
      </div>
    </div>

    <!-- Matches -->
    <div 
      class="p-1.5 text-xs uppercase leading-tight font-medium flex items-end sticky z-30 left-0 bg-inherit animated"
      :class="[
        hasScrolled ? 'right-shadow min-w-44 max-w-44' : 'min-w-80 max-w-80'
      ]"
    >
      {{ $t(`fixtures.matches`) }}
    </div>

    <!-- Dynamic fields -->
    <div 
      v-for="field in fields" 
      :key="`head-${field.data_field.id}`"
      class="border-l border-gray-200 dark:border-neutral-700"
    >
      <!-- Field label -->
      <div class="font-semibold p-2">
        {{ $t(`data_fields.${field.data_field.code}`) }}
      </div>

      <!-- Statistics -->
      <div 
        v-if="field.data_field.field_type === 'statistic'" 
        class="flex"
      >
        <div 
          v-for="m in statisticMetrics" 
          :key="m.label"
          class="min-w-15 max-w-15 relative p-1.5 flex text-xs uppercase leading-tight font-medium"
          :class="getSortCellClass(field.data_field.code, m)"
          @click="toggleSort(field.data_field.code, m)"
        >
          {{ $t(m.label) }}
          <span v-if="m.metric" class="material-symbols-outlined !font-bold !text-base absolute top-0 right-0">
            {{ getSortIcon(field.data_field.code, m) }}
          </span>
        </div>
      </div>

      <!-- Facts -->
      <div 
        v-else-if="field.data_field.field_type === 'fact'" 
        class="flex"
      >
        <div 
          v-for="m in factMetrics" 
          :key="m.label"
          class="min-w-15 max-w-15 relative p-1.5 flex text-xs uppercase leading-tight font-medium"
          :class="getSortCellClass(field.data_field.code, m)"
          @click="toggleSort(field.data_field.code, m)"
        >
          {{ $t(m.label) }}
          <span v-if="m.metric" class="material-symbols-outlined !font-bold !text-base absolute top-0 right-0">
            {{ getSortIcon(field.data_field.code, m) }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { inject, ref } from 'vue'

defineProps({
  fields: Array,
  hasScrolled: Boolean
})

const form = inject('form')

const kickOffColumn = ref({ 
  label: 'fixtures.kick_off', metric: 'kick_off', location: null, fieldType: null
})

const statisticMetrics = [
  { label: 'fixtures.metrics.home_average.short_label', metric: 'average', location: 1, fieldType: 1 },
  { label: 'fixtures.metrics.away_average.short_label', metric: 'average', location: 2, fieldType: 1 },
  { label: 'fixtures.metrics.total_average.short_label', metric: 'overall', location: 1, fieldType: 1 },
  { label: 'fixtures.metrics.home_average_by_period.short_label', metric: 'average_by_period', location: 1, fieldType: 1 },
  { label: 'fixtures.metrics.away_average_by_period.short_label', metric: 'average_by_period', location: 2, fieldType: 1 },
  { label: 'fixtures.metrics.total_average_by_period.short_label', metric: 'overall_by_period', location: 1, fieldType: 1 },
  { label: 'fixtures.metrics.home_total.label', metric: 'total', location: 1, fieldType: 1 },
  { label: 'fixtures.metrics.away_total.label', metric: 'total', location: 2, fieldType: 1 }
]

const factMetrics = [
  { label: 'fixtures.metrics.home_percentage.short_label', metric: 'percentage', location: 1, fieldType: 2 },
  { label: 'fixtures.metrics.away_percentage.short_label', metric: 'percentage', location: 2, fieldType: 2 },
  { label: 'fixtures.metrics.percentage_average.short_label', metric: 'average', location: 1, fieldType: 2 },
  { label: 'fixtures.metrics.home_total.label', metric: 'total', location: 1, fieldType: 2 },
  { label: 'fixtures.metrics.away_total.label', metric: 'total', location: 2, fieldType: 2 },
  { label: 'fixtures.metrics.home_streak.label', metric: 'streak', location: 1, fieldType: 2 },
  { label: 'fixtures.metrics.away_streak.label', metric: 'streak', location: 2, fieldType: 2 }
]

// Helpers
function toggleSort(fieldCode, m) {
  if (!m.metric) return
  let direction = 'asc'
  if (isSortActive(fieldCode, m)) {
    direction = form.sort.direction === 'asc' ? 'desc' : 'asc'
  }
  form.sort = {
    direction,
    field_code: fieldCode,
    field_type: m.fieldType,
    location: m.location,
    metric: m.metric
  }
}

function isSortActive(fieldCode, m) {
  const s = form.sort
  return (
    s.field_code === fieldCode &&
    s.field_type === m.fieldType &&
    s.location === m.location &&
    s.metric === m.metric
  )
}

function getSortCellClass(fieldCode, m) {
  if (!m.metric) return ''
  return isSortActive(fieldCode, m)
    ? 'bg-black text-white hover:bg-gray-800 dark:bg-white dark:text-black dark:hover:bg-gray-200 cursor-pointer'
    : 'hover:bg-gray-200 dark:hover:bg-neutral-800 cursor-pointer'
}

function getSortIcon(fieldCode, m) {
  if (!isSortActive(fieldCode, m)) return ''
  return form.sort.direction === 'desc' ? 'keyboard_arrow_down' : 'keyboard_arrow_up'
}
</script>
