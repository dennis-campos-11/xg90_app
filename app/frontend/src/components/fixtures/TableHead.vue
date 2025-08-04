<!-- components/FixtureTableHead.vue -->
<template>
  <tr class="relative after:header-border-b">
    <th class="bg-white dark:bg-black"></th>
    <th class="sticky left-0 bg-white dark:bg-black" :class="{ 'right-shadow': hasScrolled }"></th>
    <th v-for="field in fields" :key="`head-${field.data_field.id}`" :colspan="colspan(field.data_field.field_type)"
      class="px-3 h-12 font-medium bg-white dark:bg-black">
      {{ $t(`data_fields.${field.data_field.code}`) }}
    </th>
  </tr>
  <tr class="text-xs uppercase bg-gray-100 relative after:header-border-b dark:bg-neutral-900">
    <th class="font-semibold px-3 h-10 min-w-22 max-w-22 whitespace-nowrap text-center">{{ $t(`fixtures.kick_off`) }}
    </th>
    <th class="font-semibold px-3 h-10 min-w-50 max-w-50 sticky left-0 bg-inherit"
      :class="{ 'right-shadow': hasScrolled }">{{ $t(`fixtures.matches`) }}</th>
    <template v-for="field in fields">
      <template v-if="field.data_field.field_type === 'statistic'">
        <th class="font-semibold px-3 h-10 min-w-18 max-w-18" :key="`field-${field.id}-stats-avg`">{{
          $t(`fixtures.metrics.average.short_label`) }}</th>
        <th class="font-semibold px-3 h-10 min-w-24 max-w-24" :key="`field-${field.id}-stats-avg-diff`"
          v-if="showDifference">{{ $t(`fixtures.metrics.average_variance.short_label`) }}</th>
        <th class="font-semibold px-3 h-10 min-w-18 max-w-18" :key="`field-${field.id}-stats-avg90`">{{
          $t(`fixtures.metrics.average_by_period.short_label`) }}</th>
        <th class="font-semibold px-3 h-10 min-w-22 max-w-22" :key="`field-${field.id}-stats-avg90-diff`"
          v-if="showDifference">{{ $t(`fixtures.metrics.average_90_variance.short_label`) }}</th>
        <th class="font-semibold px-3 h-10 min-w-18 max-w-18" :key="`field-${field.id}-stats-total`">{{
          $t(`fixtures.metrics.total.short_label`) }}</th>
      </template>
      <template v-else-if="field.data_field.field_type === 'fact'">
        <th class="font-semibold px-3 h-10 min-w-18 max-w-18" :key="`field-${field.id}-facts-percentage`">{{
          $t(`fixtures.metrics.percentage.label`) }}</th>
        <th class="font-semibold px-3 h-10 min-w-22 max-w-22" :key="`field-${field.id}-stats-percentage-diff`"
          v-if="showDifference">{{ $t(`fixtures.metrics.percentage_variance.short_label`) }}</th>
        <th class="font-semibold px-3 h-10 min-w-18 max-w-18" :key="`field-${field.id}-facts-total`">{{
          $t(`fixtures.metrics.total.label`) }}</th>
        <th class="font-semibold px-3 h-10 min-w-18 max-w-18" :key="`field-${field.id}-facts-streak`">{{
          $t(`fixtures.metrics.streak.label`) }}</th>
      </template>
    </template>
  </tr>
</template>

<script setup>
const props = defineProps({
  fields: Array,
  hasScrolled: Boolean,
  showDifference: Boolean
})

function colspan(data_type) {
  if (data_type === 'statistic') {
    return props.showDifference ? 5 : 3
  } else if (data_type === 'fact') {
    return props.showDifference ? 4 : 3
  }
  return 1
}
</script>
