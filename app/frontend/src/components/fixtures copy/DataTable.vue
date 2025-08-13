<template>
  <div class="text-sm" v-if="fixtureList && activeFields.length > 0">
    <div ref="tableWrapperHead" class="w-full overflow-x-auto sticky top-15 z-20 scrollbar-hidden"
      @scroll="syncScroll('head')">
      <table class="w-full border-collapse text-left" v-if="fixtures.length">
        <thead class="sticky top-20 bg-white z-30 dark:bg-neutral-900">
          <TableHead :fields="activeFields" :hasScrolled="hasScrolled" />
        </thead>
      </table>
    </div>

    <div ref="tableWrapperBody" class="w-full overflow-x-auto" @scroll="syncScroll('body')">
      <table class="w-full table-auto border-collapse text-left">
        <tbody>
          <template v-for="(fixture, index) in fixtures" :key="`fixture-${fixture.id}`">
            <TeamRow :fixture="fixture" :index="index" :team="fixture.home"
              team-type="home" opponent-type="away" :fields="activeFields" :has-scrolled="hasScrolled"
              :is-first-row="true" :is-last-row="false" :hovered-index="hoveredIndex"
              @hover="handleHover" />
            <TeamRow :fixture="fixture" :index="index" :team="fixture.away"
              team-type="away" opponent-type="home" :fields="activeFields" :has-scrolled="hasScrolled"
              :is-first-row="false" :is-last-row="true" :hovered-index="hoveredIndex"
              @hover="handleHover" />
          </template>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import TeamRow from './TeamRow.vue'
import TableHead from './TableHead.vue'

const hoveredIndex = ref(null)

const tableWrapperHead = ref(null)
const tableWrapperBody = ref(null)
let isSyncingScroll = false

const props = defineProps({
  fixtureList: Object,
  fixtures: Array
})

const handleHover = (index) => {
  hoveredIndex.value = index
}

const hasScrolled = ref(false)

const activeFields = computed(() =>
  props.fixtureList.fixture_list_fields.filter(f => !f._destroy)
)

const syncScroll = (source) => {
  if (isSyncingScroll) return
  isSyncingScroll = true

  const head = tableWrapperHead.value
  const body = tableWrapperBody.value

  if (source === 'head') {
    body.scrollLeft = head.scrollLeft
  } else {
    head.scrollLeft = body.scrollLeft
  }

  requestAnimationFrame(() => {
    isSyncingScroll = false
  })

  hasScrolled.value = body.scrollLeft > 75
}
</script>
<style scoped>
.scrollbar-hidden::-webkit-scrollbar {
  display: none;
}

.scrollbar-hidden {
  scrollbar-width: none;
  /* Firefox */
  -ms-overflow-style: none;
  /* IE and Edge */
}
</style>