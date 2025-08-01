<template>
  <div class="flex flex-col justify-center flex-1 px-6 py-12 lg:px-20">
    <div class="mx-auto w-full max-w-md space-y-8">
      <h2 class="text-2xl font-bold mb-4">Reset your password</h2>
      <form @submit.prevent="handleSubmit">
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700">New Password</label>
          <input v-model="password" type="password" :class="[
            'mt-1 w-full rounded-md focus:ring-blue-500 focus:border-blue-500',
            errors?.value?.password ? 'border-red-500' : 'border-gray-300'
          ]">
          <div v-if="errors?.value?.password" class="text-red-500 text-sm">
            <div v-for="msg in errors.value.password" :key="msg">{{ msg }}</div>
          </div>
        </div>
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700">Confirm Password</label>
          <input v-model="passwordConfirmation" type="password" :class="[
            'mt-1 w-full rounded-md focus:ring-blue-500 focus:border-blue-500',
            errors?.value?.password_confirmation ? 'border-red-500' : 'border-gray-300'
          ]">
          <div v-if="errors?.value?.password_confirmation" class="text-red-500 text-sm">
            <div v-for="msg in errors.value.password_confirmation" :key="msg">{{ msg }}</div>
          </div>
        </div>
        <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
          Reset Password
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { useRoute, useRouter } from 'vue-router'
import { ref } from 'vue'
import { reactive } from 'vue'
import { resetPassword } from '@/api/auth'
import { showAlert } from "@/stores/alert"

const password = ref('')
const passwordConfirmation = ref('')
const errors = reactive({})
const router = useRouter()
const route = useRoute()
const token = route.query.token

const handleSubmit = async () => {
  try {
    const data = await resetPassword(token, password.value, passwordConfirmation.value)
    showAlert(data?.message, 'success')
    router.push('/sign_in')
  } catch (error) {
    errors.value = error?.errors || {}
    const error_message = error?.message
    showAlert(error_message, 'error')
  }
}
</script>
