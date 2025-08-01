<template>
  <div
    ref="tableWrapperHead"
    class="w-full overflow-x-auto sticky top-15 z-20 scrollbar-hidden"
    @scroll="syncScroll('head')"
  >
    <table class="w-full border-collapse text-left text-sm" v-if="groupedFixtures.length">
      <thead class="sticky top-20 bg-white z-30 dark:bg-black">
        <TableHead
          :fields="activeFields"
          :hasScrolled="hasScrolled"
          :show-difference="fixtureList.show_variance_against_competition"
        />
      </thead>
    </table>
  </div>

  <div
    ref="tableWrapperBody"
    class="w-full overflow-x-auto"
    @scroll="syncScroll('body')"
  >
    <table class="w-full table-auto border-collapse text-left text-sm">
      <tbody>
        <template v-for="group in groupedFixtures" :key="`group-${group.competition.id}`">
          <CompetitionRow
            :competition="group.competition"
            :hasScrolled="hasScrolled"
          />
          <template v-for="(fixture, index) in group.fixtures" :key="`fixture-${fixture.id}`">
            <TeamRow
              :competition="group.competition"
              :fixture="fixture"
              :index="index"
              :team="fixture.home"
              team-type="home"
              opponent-type="away"
              :fields="activeFields"
              :has-scrolled="hasScrolled"
              :is-first-column="true"
              :is-last-column="false"
              :hovered-index="hoveredIndex"
              :show-difference="fixtureList.show_variance_against_competition"
              @hover="handleHover"
            />
            <TeamRow
              :competition="group.competition"
              :fixture="fixture"
              :index="index"
              :team="fixture.away"
              team-type="away"
              opponent-type="home"
              :fields="activeFields"
              :has-scrolled="hasScrolled"
              :is-first-column="false"
              :is-last-column="true"
              :hovered-index="hoveredIndex"
              :show-difference="fixtureList.show_variance_against_competition"
              @hover="handleHover"
            />
          </template>
        </template>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import CompetitionRow from './CompetitionRow.vue'
import TeamRow from './TeamRow.vue'
import TableHead from './TableHead.vue'

const hoveredIndex = ref(null)

const tableWrapperHead = ref(null)
const tableWrapperBody = ref(null)
let isSyncingScroll = false

const props = defineProps({
  fixtureList: Object,
  groupedFixtures: Array
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
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE and Edge */
}
</style>