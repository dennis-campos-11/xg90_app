<!-- components/FixtureTableHead.vue -->
<template>
  <tr class="relative after:header-border-b">
    <th></th>
    <th class="sticky left-0 bg-white" :class="{ 'right-shadow': hasScrolled }"></th>
    <th v-for="field in fields" :key="`head-${field.data_field.id}`" :colspan="3" class="px-6 h-12 font-normal">
      {{ $t(`data_fields.${field.data_field.code}`) }}
    </th>
  </tr>
  <tr class="text-xs uppercase bg-white text-gray-500 relative after:header-border-b">
    <th class="font-medium px-4 h-12 whitespace-nowrap">Kick Off</th>
    <th class="font-medium px-4 h-12 whitespace-nowrap sticky left-0 bg-inherit"
      :class="{ 'right-shadow': hasScrolled }">Matches</th>
    <template v-for="field in fields">
      <template v-if="field.data_field.field_type === 'statistic'">
        <th class="font-medium px-6 h-12 whitespace-nowrap" :key="`field-${field.id}-stats-avg`">Avg</th>
        <th class="font-medium px-6 h-12 whitespace-nowrap" :key="`field-${field.id}-stats-avg90`">Avg90</th>
        <th class="font-medium px-6 h-12 whitespace-nowrap" :key="`field-${field.id}-stats-total`">Tot</th>
      </template>
      <template v-else-if="field.data_field.field_type === 'fact'">
        <th class="font-medium px-6 h-12 whitespace-nowrap" :key="`field-${field.id}-facts-rate`">Rate</th>
        <th class="font-medium px-6 h-12 whitespace-nowrap" :key="`field-${field.id}-facts-total`">Tot</th>
        <th class="font-medium px-6 h-12 whitespace-nowrap" :key="`field-${field.id}-facts-streak`">Str</th>
      </template>
    </template>
  </tr>
</template>

<script setup>
defineProps({
  fields: Array,
  hasScrolled: Boolean
})
</script>
