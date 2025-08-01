import axios from 'axios'
import router from '@/router'
import { useUserStore } from './stores/user'

const api = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
  headers: {
    'Content-Type': 'application/json',
  },
})

// Añadir token automáticamente
api.interceptors.request.use((config) => {
  const store = useUserStore()
  if (store.token) {
    config.headers.Authorization = `Bearer ${store.token}`
  }
  config.headers.Accept = 'application/json'
  return config
})

api.interceptors.response.use(
  response => response,
  error => {
    const store = useUserStore()

    if (error.response) {
      const status = error.response.status

      if (status === 401) {
        store.logout()
        router.push('/sign_in')
      }

      return Promise.reject({
        message: error.response.data?.message,
        errors: error.response.data?.errors,
        status: error.response.status,
      })
    }

    return Promise.reject({
      status: 500,
      message: 'Unable to reach the server. Please try again later.',
      data: null,
    })
  }
)

export default api
