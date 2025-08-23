<template>
  <div v-if="fixtures?.length > 0 && fixtureList && activeFields?.length > 0">
    <div
      ref="tableWrapperHead"
      class="w-full overflow-x-auto border-b border-black dark:border-neutral-800 bg-white dark:bg-black sticky top-15 z-20 scrollbar-hidden"
      @scroll="syncScroll('head')"
    >
      <TableHead :fields="activeFields" :hasScrolled="hasScrolled" />
    </div>

    <div
      ref="tableWrapperBody"
      class="w-full flex flex-col overflow-x-auto"
      @scroll="syncScroll('body', $event.target)"
    >
      <template v-for="fixture in sortedFixtures" :key="fixture.id">
        <div
          class="w-full bg-white dark:bg-black hover:bg-gray-100 dark:hover:bg-neutral-800 animated scrollbar-hidden"
        >
          <TeamRow :fixture="fixture" :fields="activeFields" :has-scrolled="hasScrolled" />
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, inject } from 'vue'
import TeamRow from './TeamRow.vue'
import TableHead from './TableHead.vue'
import { useFixtureList } from '@/composables/useFixtureList'

const tableWrapperHead = ref(null)
const tableWrapperBody = ref(null)

let isSyncingScroll = false

const props = defineProps({
  fixtureList: Object,
  fixtures: Array,
  metaData: Object
})

const hasScrolled = ref(false)
const form = inject('form')

const {
  availableItems: activeFields,
} = useFixtureList(form, props, 'fixture_list_fields_attributes', 'data_field', ['code'])

const syncScroll = (source, el = null) => {
  if (isSyncingScroll) return
  isSyncingScroll = true

  const head = tableWrapperHead.value
  const body = tableWrapperBody.value

  if (source === 'head' && body) {
    body.scrollLeft = head.scrollLeft
  } else if (source === 'body' && head) {
    head.scrollLeft = el.scrollLeft
  }

  requestAnimationFrame(() => {
    isSyncingScroll = false
  })

  hasScrolled.value = head?.scrollLeft > 0
}

const sortedFixtures = computed(() => {
  let { field_code, field_type, metric, location, direction } = form.sort

  return [...props.fixtures].sort((a, b) => {
    if (field_code === "kick_off") {
      const valA = new Date(a.starting_at).getTime() || 0
      const valB = new Date(b.starting_at).getTime() || 0
      return direction === "asc" ? valA - valB : valB - valA
    }

    let targetA =
      field_type === 1
        ? (location === 1 ? a.home_processed_stats : a.away_processed_stats)
        : (location === 1 ? a.home_processed_facts : a.away_processed_facts)

    let targetB =
      field_type === 1
        ? (location === 1 ? b.home_processed_stats : b.away_processed_stats)
        : (location === 1 ? b.home_processed_facts : b.away_processed_facts)

    let valA = targetA?.[field_code]?.[metric] || 0
    let valB = targetB?.[field_code]?.[metric] || 0

    return direction === "asc" ? valA - valB : valB - valA
  })
})

</script>

<style scoped>
.scrollbar-hidden::-webkit-scrollbar {
  display: none;
}

.scrollbar-hidden {
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE y Edge */
}
</style>
