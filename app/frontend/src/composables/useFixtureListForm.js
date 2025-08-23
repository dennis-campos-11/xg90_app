import { ref, reactive, onMounted } from 'vue'
import fixtureListsApi from '@/api/fixture_list'
import { useRoute } from 'vue-router'

export function useFixtureListForm(loadId = false) {
  const route = useRoute()
  const fixtureLists = ref([])
  const fixtureListMeta = ref({})
  const fixtures = ref(null)
  const fixtureList = ref(null)
  const selectedFixtureList = ref(null)

  const form = reactive({
    id: null,
    name: null,
    total_matches: 20,
    season_index: 1,
    home_location: 1,
    away_location: 2,
    fixture_date: 0,
    fixture_list_fields_attributes: [],
    fixture_list_competitions_attributes: [],
    sort: {
      field_code: "kick_off",
      field_type: null,
      metric: "kick_off",
      location: null,
      direction: "asc"
    },
    settings: {
      general: {
        only_current_competition: false,
        highlight_cells: true
      },
      statistics: {
        show_total_average: true,
        show_total_average_per_period: true,
        show_totals: true
      },
      facts: {
        show_percentage_average: true,
        show_totals: true
      }
    }
  })

  const search = async (params = {}) => {
    const data = await fixtureListsApi.search({ fixture_list: params })
    fixtures.value = data?.fixtures || []
    fixtureList.value = data?.fixture_list
  }

  const getFixtureList = async (id) => {
    if (!id) return
    const data = await fixtureListsApi.get(id)
    selectedFixtureList.value = data?.fixture_list
  }

  const getAllFixtureLists = async () => {
    const data = await fixtureListsApi.getAll()
    fixtureLists.value = data
  }

  const getFixtureListMeta = async () => {
    const data = await fixtureListsApi.meta()
    fixtureListMeta.value = data
  }

  onMounted(() => {
    getAllFixtureLists()
    getFixtureListMeta()
    if (loadId) {
      const id = route.params.id
      getFixtureList(id)
    }
  })

  return {
    fixtureLists,
    fixtureListMeta,
    fixtures,
    fixtureList,
    selectedFixtureList,
    form,
    search,
    getFixtureList,
    getAllFixtureLists,
    getFixtureListMeta
  }
}
