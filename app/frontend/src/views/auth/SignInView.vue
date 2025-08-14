<template>
  <!-- Left: Login Form -->
  <div class="flex flex-col justify-center flex-1 px-6 py-12 lg:px-20">
    <div class="mx-auto w-full max-w-md space-y-8">
      <div>
        <h2 class="mt-6 text-3xl font-extrabold text-gray-900">Welcome back</h2>
      </div>
      <div class="flex space-x-4">
        <button
          class="flex items-center justify-center gap-2 w-full border border-gray-300 rounded-md py-2 hover:bg-gray-100 focus:ring-4 focus:ring-gray-200">
          <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="25" height="25" viewBox="0 0 48 48">
            <path fill="#fbc02d"
              d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8c-6.627,0-12-5.373-12-12	s5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C12.955,4,4,12.955,4,24s8.955,20,20,20	s20-8.955,20-20C44,22.659,43.862,21.35,43.611,20.083z">
            </path>
            <path fill="#e53935"
              d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12c3.059,0,5.842,1.154,7.961,3.039	l5.657-5.657C34.046,6.053,29.268,4,24,4C16.318,4,9.656,8.337,6.306,14.691z">
            </path>
            <path fill="#4caf50"
              d="M24,44c5.166,0,9.86-1.977,13.409-5.192l-6.19-5.238C29.211,35.091,26.715,36,24,36	c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025C9.505,39.556,16.227,44,24,44z">
            </path>
            <path fill="#1565c0"
              d="M43.611,20.083L43.595,20L42,20H24v8h11.303c-0.792,2.237-2.231,4.166-4.087,5.571	c0.001-0.001,0.002-0.001,0.003-0.002l6.19,5.238C36.971,39.205,44,34,44,24C44,22.659,43.862,21.35,43.611,20.083z">
            </path>
          </svg>
          <span class="font-medium">Sign in with Google</span>
        </button>
      </div>
      <div class="relative my-4">
        <div class="absolute inset-0 flex items-center">
          <div class="w-full border-t border-gray-300"></div>
        </div>
        <div class="relative flex justify-center">
          <span class="bg-white px-2 text-gray-500">or</span>
        </div>
      </div>
      <form class="space-y-6" @submit.prevent="handleLogin">
        <div>
          <label for="email" class="block font-medium text-gray-700">Email</label>
          <input v-model="email" type="email" autocomplete="email"
            class="text-sm mt-1 w-full border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
        </div>
        <div>
          <label for="password" class="block font-medium text-gray-700">Password</label>
          <input v-model="password" type="password" autocomplete="current-password"
            class="text-sm mt-1 w-full border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
        </div>
        <div class="flex items-center justify-between">
          <label class="flex items-center">
            <input type="checkbox" class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
            <span class="ml-2 text-gray-900">Remember me</span>
          </label>
          <div>
            <router-link to="/forgot_password" class="font-medium text-blue-600 hover:text-blue-500">
              Forgot password
            </router-link>
          </div>
        </div>
        <div>
          <button type="submit"
            class="w-full flex justify-center py-2 px-2 border border-transparent rounded-md shadow-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:ring-4 focus:ring-blue-300">
            Sign in to your account
          </button>
        </div>
      </form>
      <div class="text-center text-gray-600">
        Don't have an account?
        <router-link to="/sign_up" class="font-medium text-blue-600 hover:text-blue-500">
          Sign up
        </router-link>
      </div>
    </div>
  </div>

</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../../stores/user'
import { showAlert } from "@/stores/alert"

const email = ref('')
const password = ref('')
const router = useRouter()
const userStore = useUserStore()

const handleLogin = async () => {
  try {
    const data = await userStore.signIn(email.value, password.value)
    showAlert(data?.message, 'success')
    router.push('/protected')
  } catch (error) {
    const error_message = error?.message
    showAlert(error_message, 'error')
  }
}
</script>
