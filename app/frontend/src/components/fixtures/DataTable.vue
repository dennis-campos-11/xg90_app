<template>
  <div v-if="fixtures.length > 0 && fixtureList && activeFields.length > 0">
    <!-- Head -->
    <div
      ref="tableWrapperHead"
      class="w-full overflow-x-auto border-0 bg-white dark:bg-black sticky top-15 z-20 scrollbar-hidden"
      @scroll="syncScroll('head')"
    >
      <TableHead :fields="activeFields" :hasScrolled="hasScrolled" />
    </div>

    <!-- Body -->
    <div
      ref="tableWrapperBody"
      class="w-full flex flex-col overflow-x-auto"
      @scroll="syncScroll('body', $event.target)"
    >
      <template v-for="fixture in fixtures" :key="fixture.id">
        <div
          class="w-full bg-white dark:bg-black animated scrollbar-hidden"
        >
          <TeamRow :fixture="fixture" :fields="activeFields" :has-scrolled="hasScrolled" />
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import TeamRow from './TeamRow.vue'
import TableHead from './TableHead.vue'

const tableWrapperHead = ref(null)
const tableWrapperBody = ref(null)

let isSyncingScroll = false

const props = defineProps({
  fixtureList: Object,
  fixtures: Array
})

const hasScrolled = ref(false)

const activeFields = computed(() =>
  props.fixtureList.fixture_list_fields.filter(f => !f._destroy)
)

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
