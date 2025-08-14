<template>
  <div class="flex flex-col justify-center flex-1 px-6 py-12 lg:px-20">
    <div class="mx-auto w-full max-w-md space-y-8">
      <h2 class="text-2xl font-bold mb-4">Forgot your password?</h2>
      <p class="text-gray-600 mb-4">
        Enter your email and we'll send you a link to reset your password.
      </p>
      <form @submit.prevent="handleSubmit">
        <div class="mb-6">
          <label class="block font-medium text-gray-700">Email</label>
          <input v-model="email" type="email"
            class="text-sm mt-1 w-full rounded-md border-gray-300 focus:ring-blue-500 focus:border-blue-500">
        </div>
        <button type="submit"
          class="w-full flex justify-center py-2 px-2 border border-transparent rounded-md shadow-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:ring-4 focus:ring-blue-300">
          Send Reset Link
        </button>
      </form>
      <div class="text-center text-gray-600">
        Back to
        <router-link to="/sign_in" class="font-medium text-blue-600 hover:text-blue-500">
          Sign in
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { ref } from 'vue'
import { forgotPassword } from '@/api/auth'
import { showAlert } from "@/stores/alert"


const router = useRouter()
const email = ref('')

const handleSubmit = async () => {
  try {
    const data = await forgotPassword(email.value)
    showAlert(data?.message, 'success')
    router.push('/sign_in')
  } catch (error) {
    const error_message = error?.message
    showAlert(error_message, 'error')
  }
}
</script>