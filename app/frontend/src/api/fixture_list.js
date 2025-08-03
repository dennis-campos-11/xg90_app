import api from '@/api'

const fixtureLists = {
  async meta() {
    const response = await api.get(`/fixture_lists/meta`)
    return response.data
  },

  async getAll() {
    const response = await api.get(`/fixture_lists`)
    return response.data
  },

  async get(id) {
    const response = await api.get(`/fixture_lists/${id}`)
    return response.data
  },

  async create(payload) {
    const response = await api.post(`/fixture_lists`, payload)
    return response.data
  },

  async update(id, payload) {
    const response = await api.put(`/fixture_lists/${id}`, payload)
    return response.data
  },

  async search(payload) {
    const response = await api.post(`/fixture_lists/search`, payload)
    return response.data
  }
}

export default fixtureLists