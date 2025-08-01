import api from "@/api";

export async function updateSettings(payload) {
  const response = await api.patch('/user_settings', { user: payload })
  return response.data
}

export async function fetchCurrentUser() {
  const response = await api.get('/me')
  return response.data
}