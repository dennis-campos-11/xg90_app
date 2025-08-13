<template>
  <div class="flex min-w-max py-3 bg-white dark:bg-neutral-950">
    <div class="min-w-22 max-w-22 font-medium">
      {{ $t(`fixtures.kick_off`) }}
    </div>
    <div class="min-w-50 max-w-50 font-medium sticky left-0 bg-white dark:bg-neutral-950"
      :class="{ 'border-r border-gray-200 dark:border-neutral-700': hasScrolled }">
      {{ $t(`fixtures.matches`) }}
    </div>
    <div v-for="field in fields" :key="`head-${field.data_field.id}`" class="px-5">
      <div class="font-medium mb-1">{{ $t(`data_fields.${field.data_field.code}`) }}</div>

      <div class="flex gap-3 text-sm"
        v-if="field.data_field.field_type === 'statistic'">
        <div class="min-w-12">{{
          $t(`fixtures.metrics.average.short_label`) }}
        </div>
        <div class="min-w-12">{{
          $t(`fixtures.metrics.average_overall.short_label`) }}
        </div>
        <div class="min-w-12">{{
          $t(`fixtures.metrics.average_by_period.short_label`) }}
        </div>
        <div class="min-w-12">{{
          $t(`fixtures.metrics.average_by_period_overall.short_label`) }}
        </div>
        <div class="min-w-9">{{
          $t(`fixtures.metrics.total.short_label`) }}
        </div>
      </div>
      <div class="flex gap-3 text-sm"
        v-else-if="field.data_field.field_type === 'fact'">
        <div class="min-w-12">{{
          $t(`fixtures.metrics.percentage.short_label`) }}
        </div>
        <div class="min-w-14">{{
          $t(`fixtures.metrics.percentage_average.short_label`) }}
        </div>
        <div class="min-w-9">{{
          $t(`fixtures.metrics.total.short_label`) }}
        </div>
        <div class="min-w-9">{{
          $t(`fixtures.metrics.streak.short_label`) }}
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
