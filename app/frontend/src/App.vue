<script setup>
import { RouterView } from 'vue-router'
import { computed, onMounted, watch } from 'vue'
import { alert } from '@/stores/alert'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()

onMounted(() => {
  userStore.loadUser()
  setHtmlTheme(localStorage.getItem('theme') || 'light')
})

const setHtmlTheme = (theme) => {
  const html = document.documentElement
  html.classList.add('disable-transitions')

  if (theme === 'dark') {
    html.classList.add('dark')
  } else {
    html.classList.remove('dark')
  }
  window.requestAnimationFrame(() => {
    html.classList.remove('disable-transitions')
  })
}

watch(() => userStore.user?.appearance, (theme) => {
  setHtmlTheme(theme)
})

const alertClass = computed(() => {
  switch (alert.value.type) {
    case 'success':
      return 'text-white bg-green-500'
    case 'error':
      return 'text-white bg-red-500'
    default:
      return 'text-white bg-blue-500'
  }
})
</script>

<template>
  <div class="w-screen">
    <div v-if="alert.show" :class="alertClass" role="alert"
      class="fixed top-0 w-full p-4 mb-4 flex justify-between z-60">
      <span class="font-medium">{{ alert.message }}</span>
      <button type="button"
        class="ms-auto -mx-1.5 -my-1.5 p-1.5 inline-flex items-center justify-center h-8 w-8 opacity-70 hover:opacity-100"
        @click="alert.show = false">
        <span class="material-symbols-outlined">
          close
        </span>
      </button>
    </div>
    <RouterView />
  </div>
</template>