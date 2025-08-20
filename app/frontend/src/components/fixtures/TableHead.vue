<template>
  <div class="flex min-w-max bg-inherit">
    <div class="min-w-18 max-w-18 p-2 font-semibold">
      {{ $t(`fixtures.kick_off`) }}
    </div>
    <div 
      class="p-2 font-semibold sticky z-30 left-0 bg-inherit animated"
      :class="[
        hasScrolled ? 'right-shadow min-w-44 max-w-44' : 'min-w-80 max-w-80'
      ]"
    >
      {{ $t(`fixtures.matches`) }}
    </div>
    <div 
      v-for="field in fields" 
      :key="`head-${field.data_field.id}`"
      class="border-l border-gray-200 dark:border-neutral-700"
    >
      <div class="font-semibold p-2">
        {{ $t(`data_fields.${field.data_field.code}`) }}
      </div>

      <div class="flex text-xs uppercase leading-tight py-1 font-medium"
        v-if="field.data_field.field_type === 'statistic'">
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.home_average.short_label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.away_average.short_label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.total_average.short_label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.home_average_by_period.short_label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.away_average_by_period.short_label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.total_average_by_period.short_label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.home_total.label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.away_total.label`) }}
        </div>
      </div>
      <div class="flex text-xs uppercase leading-tight py-1 font-medium"
        v-else-if="field.data_field.field_type === 'fact'">
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.home_percentage.short_label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.away_percentage.short_label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.percentage_average.short_label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.home_total.label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.away_total.label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.home_streak.label`) }}
        </div>
        <div class="min-w-15 max-w-15 px-1.5">{{
          $t(`fixtures.metrics.away_streak.label`) }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  fields: Array,
  hasScrolled: Boolean
})
</script>
