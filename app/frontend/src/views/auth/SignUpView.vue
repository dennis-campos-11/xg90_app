<template>
  <!-- Left: Sign Up Form -->
  <div class="flex flex-col justify-center flex-1 px-6 py-12 lg:px-20">
    <div class="mx-auto w-full max-w-md space-y-8">
      <div>
        <h2 class="mt-6 text-3xl font-extrabold text-gray-900">Create your account</h2>
      </div>
      <form class="space-y-6" @submit.prevent="handleSignUp">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block font-medium text-gray-700">First Name</label>
            <input v-model="firstName" type="text" :class="[
              'mt-1 w-full rounded-md focus:ring-blue-500 focus:border-blue-500',
              errors?.value?.first_name ? 'border-red-500' : 'border-gray-300'
            ]">
            <div v-if="errors?.value?.first_name" class="text-red-500">
              <div v-for="msg in errors.value.first_name" :key="msg">{{ msg }}</div>
            </div>
          </div>

          <div>
            <label class="block font-medium text-gray-700">Last Name</label>
            <input v-model="lastName" type="text" :class="[
              'mt-1 w-full rounded-md focus:ring-blue-500 focus:border-blue-500',
              errors?.value?.last_name ? 'border-red-500' : 'border-gray-300'
            ]">
            <div v-if="errors?.value?.last_name" class="text-red-500">
              <div v-for="msg in errors.value.last_name" :key="msg">{{ msg }}</div>
            </div>
          </div>
        </div>

        <div>
          <label class="block font-medium text-gray-700">Email</label>
          <input v-model="email" type="email" autocomplete="email" :class="[
            'mt-1 w-full rounded-md focus:ring-blue-500 focus:border-blue-500',
            errors?.value?.email ? 'border-red-500' : 'border-gray-300'
          ]">
          <div v-if="errors?.value?.email" class="text-red-500">
            <div v-for="msg in errors.value.email" :key="msg">{{ msg }}</div>
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block font-medium text-gray-700">Password</label>
            <input v-model="password" type="password" autocomplete="new-password" :class="[
              'mt-1 w-full rounded-md focus:ring-blue-500 focus:border-blue-500',
              errors?.value?.password ? 'border-red-500' : 'border-gray-300'
            ]">
            <div v-if="errors?.value?.password" class="text-red-500">
              <div v-for="msg in errors.value.password" :key="msg">{{ msg }}</div>
            </div>
          </div>

          <div>
            <label class="block font-medium text-gray-700">Confirm Password</label>
            <input v-model="passwordConfirmation" type="password" :class="[
              'mt-1 w-full rounded-md focus:ring-blue-500 focus:border-blue-500',
              errors?.value?.password_confirmation ? 'border-red-500' : 'border-gray-300'
            ]">
            <div v-if="errors?.value?.password_confirmation" class="text-red-500">
              <div v-for="msg in errors.value.password_confirmation" :key="msg">{{ msg }}</div>
            </div>
          </div>
        </div>

        <div>
          <button type="submit"
            class="w-full flex justify-center py-2 px-2 border border-transparent rounded-md shadow-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:ring-4 focus:ring-blue-300">
            Create Account
          </button>
        </div>
      </form>

      <div class="text-center text-gray-600">
        Already have an account?
        <router-link to="/sign_in" class="font-medium text-blue-600 hover:text-blue-500">
          Sign in
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { showAlert } from "@/stores/alert"

const firstName = ref('')
const lastName = ref('')
const email = ref('')
const password = ref('')
const passwordConfirmation = ref('')
const errors = reactive({})

const router = useRouter()
const userStore = useUserStore()

const handleSignUp = async () => {
  try {
    const data = await userStore.signUp(firstName.value, lastName.value, email.value, password.value, passwordConfirmation.value)
    showAlert(data?.message, 'success')
    router.push('/protected')
  } catch (error) {
    errors.value = error?.errors || {}
    const error_message = error?.message
    showAlert(error_message, 'error')
  }
}
</script>
