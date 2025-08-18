import { ref, computed, toRef } from 'vue'
import Fuse from 'fuse.js'

export function useFixtureList(form, props, attributeKey, relationKey, searchKeys = ['code']) {
  const search = ref('')
  const showOnlySelected = ref(false)
  const metaData = toRef(props, 'metaData')

  const relationPlural = `${relationKey}s`
  const relationIdKey = `${relationKey}_id`

  /**
   * Verifica si el item tiene filtros distintos a los defaults en settings
   */
  const checkFiltersApplied = (item, relation) => {
    if (!relation?.settings || !item.filters) return false

    for (const [key, config] of Object.entries(relation.settings)) {
      const filterConfig = item.filters?.[key]
      if (!filterConfig) continue

      for (const side of ['home', 'away']) {
        const filterSide = filterConfig?.[side]
        if (!filterSide) continue

        const defaultFrom = config.min
        const defaultTo   = config.max

        if (
          (filterSide.from !== undefined && filterSide.from !== defaultFrom) ||
          (filterSide.to   !== undefined && filterSide.to   !== defaultTo)
        ) {
          return true
        }
      }
    }
    return false
  }

  // Normaliza el listado con metadatos asociados y detecta filtros aplicados
  const availableItems = computed(() => {
    const items = form?.[attributeKey] ?? []
    const source = metaData.value?.[relationPlural] ?? []

    return items
      .filter(item => !item._destroy)
      .map(item => {
        const relation = source.find(df => df.id === item[relationIdKey]) || null

        return {
          ...item,
          [relationKey]: relation,
          hasFiltersApplied: checkFiltersApplied(item, relation),
        }
      })
      .sort((a, b) => a.index - b.index)
  })

  const hasItem = (id) =>
    form?.[attributeKey]?.some(item => item[relationIdKey] === id && !item._destroy)

  const toggleItem = (item) => {
    const items = form[attributeKey] ?? []
    const index = items.findIndex(f => f[relationIdKey] === item.id && !f._destroy)

    if (index !== -1) {
      const current = items[index]
      current.id ? (current._destroy = true) : items.splice(index, 1)
    } else {
      items.push({
        id: null,
        [relationIdKey]: item.id,
        index: (items.length + 1),
        filters: {},
        _destroy: false,
      })
    }
  }

  const filteredItems = computed(() => {
    let list = metaData.value?.[relationPlural] ?? []

    if (showOnlySelected.value) {
      list = list.filter(i => hasItem(i.id))
    }

    if (search.value && list.length) {
      list = new Fuse(list, { keys: searchKeys, threshold: 0.3 })
        .search(search.value)
        .map(res => res.item)
    }

    return list
  })

  return {
    search,
    showOnlySelected,
    filteredItems,
    hasItem,
    toggleItem,
    availableItems,
  }
}
