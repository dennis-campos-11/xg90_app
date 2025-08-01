import { defineStore } from 'pinia'
import { signIn, signUp } from '@/api/auth'
import { updateSettings, fetchCurrentUser } from '@/api/user'

export const useUserStore = defineStore('user', {
  state: () => ({
    user: null,
    token: localStorage.getItem('token') || null,
  }),
  actions: {
    async signIn(email, password) {
      const data = await signIn(email, password)

      this.token = data.token
      this.user = data.user
      localStorage.setItem('token', this.token)

      return data
    },
    async signUp(firstName, lastName, email, password, passwordConfirmation) {
      const data = await signUp(firstName, lastName, email, password, passwordConfirmation)

      this.token = data.token
      this.user = data.user
      localStorage.setItem('token', this.token)

      return data
    },
    async logout() {
      this.token = null
      this.user = null
      localStorage.removeItem('token')
    },
    async updateSettings({ language, appearance }) {
      const data = await updateSettings({ language, appearance })
      this.user = data.user
    },
    async loadUser() {
      if (this.token && !this.user) {
        try {
          const data = await fetchCurrentUser()
          this.user = data.user
          localStorage.setItem('theme', this.user.appearance)
        } catch {
          this.logout()
        }
      }
    },
  },
})
