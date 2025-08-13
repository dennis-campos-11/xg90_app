<template>
  <div v-if="fixtureList && activeFields.length > 0">
    <div ref="tableWrapperHead"
      class="w-full overflow-x-auto border border-white dark:border-neutral-950 rounded-lg sticky top-15 z-20 scrollbar-hidden"
      @scroll="syncScroll('head')">
      <TableHead :fields="activeFields" :hasScrolled="hasScrolled" />
    </div>

    <div class="w-full flex flex-col gap-3">
      <template v-for="(fixture, i) in fixtures" :key="fixture.id">
        <div :ref="el => rowEls[i] = el"
          class="w-full overflow-x-auto border border-gray-200 dark:border-neutral-700 bg-white dark:bg-neutral-950 rounded-xl hover:bg-gray-100 dark:hover:bg-neutral-900 py-3 animated scrollbar-hidden"
          @scroll="syncScroll('body', $event.target)">
          <TeamRow :fixture="fixture" :fields="activeFields" :has-scrolled="hasScrolled" />
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import TeamRow from './TeamRow.vue'
import TableHead from './TableHead.vue'

const tableWrapperHead = ref(null)
const rowEls = ref([])
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
  const rows = rowEls.value

  if (source === 'head') {
    rows.forEach(r => { if (r) r.scrollLeft = head.scrollLeft })
  } else {
    head.scrollLeft = el.scrollLeft
    rows.forEach(r => {
      if (r !== el && r) r.scrollLeft = el.scrollLeft
    })
  }

  requestAnimationFrame(() => {
    isSyncingScroll = false
  })

  hasScrolled.value = head.scrollLeft > 75
}

onMounted(() => {
  // Limpieza de refs duplicados si fixtures cambia
  rowEls.value = []
})
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