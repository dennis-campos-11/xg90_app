<template>
  <div class="relative">
    <button :id="`${id}-button`" :data-dropdown-toggle="`${id}-dropdown`" data-dropdown-placement="bottom-start"
      class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-3 py-2 text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-800 animated"
      type="button">
      <span v-html="titleWithCount"></span>
      <span class="material-symbols-outlined">keyboard_arrow_down</span>
    </button>
    <div :id="`${id}-dropdown`"
      class="w-80 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 dark:divide-neutral-800">
      <div class="p-3">
        <div class="relative">
          <div class="absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none">
            <span class="material-symbols-outlined text-gray-400 dark:text-neutral-400">search</span>
          </div>
          <input v-model="search" type="text" :placeholder="searchPlaceholder"
            class="block w-full p-2 ps-10 border-0 rounded-lg bg-gray-100 focus-visible:ring-blue-500 dark:bg-neutral-700 dark:placeholder-neutral-400 dark:focus-visible:ring-blue-500" />
        </div>
      </div>
      <ul class="h-48 p-3 overflow-y-auto">
        <li v-for="item in filteredItems" :key="`${id}-${item.id}`">
          <div class="flex items-center ps-2 rounded-sm hover:bg-gray-100 dark:hover:bg-neutral-800">
            <input type="checkbox" :id="`${id}-${item.id}`" :checked="hasItem(item.id)" @change="toggleItem(item)"
              class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-neutral-800 focus:ring-2 dark:bg-neutral-700 dark:border-neutral-600">
            <label :for="`${id}-${item.id}`" class="w-full py-2 ms-2 rounded-sm">
              {{ itemLabel(item) }}
            </label>
          </div>
        </li>
      </ul>
      <div class="flex items-center p-3 rounded-b-lg bg-gray-100 dark:bg-white/5">
        <label class="inline-flex items-center cursor-pointer">
          <input type="checkbox" v-model="showOnlySelected" class="sr-only peer" />
          <div
            class="relative w-9 h-5 bg-gray-300 rounded-full peer dark:bg-neutral-700 peer-checked:bg-blue-600 after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border after:border-neutral-300 peer-checked:after:border-blue-700 after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:after:translate-x-full">
          </div>
          <span class="ms-3 font-medium">{{ $t('miscellaneous.show_only_selected') }}</span>
        </label>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useI18n } from 'vue-i18n'
import Fuse from 'fuse.js'

const { t } = useI18n()

const props = defineProps({
  id: String,
  items: Array,
  selectedItems: Array,
  searchPlaceholder: String,
  labelKey: { type: String, default: 'name' },
  title: String
})

const emit = defineEmits(['toggle'])

const search = ref('')
const showOnlySelected = ref(false)

const filteredItems = computed(() => {
  let list = props.items || []

  if (showOnlySelected.value) {
    list = list.filter(i => hasItem(i.id))
  }

  if (search.value) {
    list = new Fuse(list, { keys: [props.labelKey], threshold: 0.3 })
      .search(search.value)
      .map(res => res.item)
  }

  return list
})

const titleWithCount = computed(() =>
  `${props.title}`
)

function hasItem(id) {
  return props.selectedItems.some(i => (i.data_field?.id || i.competition?.id) === id)
}

function toggleItem(item) {
  emit('toggle', item)
}

function itemLabel(item) {
  return props.labelKey === 'code' ? t(`data_fields.${item.code}`) : item[props.labelKey]
}
</script>
