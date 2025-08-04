<template>
  <div class="flex flex-col max-w-screen">
    <nav class="bg-white dark:bg-black sticky top-0 z-40 h-15 w-full">
      <div class="container flex flex-wrap items-center justify-between mx-auto px-4 py-2">
        <span class="text-xl font-bold">XG90</span>
        <div class="items-center justify-between hidden w-full md:flex md:w-auto md:order-1" id="navbar-cta">
          <ul class="flex flex-col font-medium space-x-8 rtl:space-x-reverse flex-row">
            <li>
              <a href="#" class="block rounded-sm hover:text-blue-600">Leagues</a>
            </li>
            <li>
              <router-link to="/fixture_lists" class="block rounded-sm hover:text-blue-600">Fixture
                Lists</router-link>
            </li>
            <li>
              <a href="#" class="block rounded-sm hover:text-blue-600">Players</a>
            </li>
          </ul>
        </div>
        <div class="items-center justify-between flex md:w-auto md:order-1" id="navbar-cta">
          <ul class="flex flex-col font-medium space-x-1 rtl:space-x-reverse flex-row">
            <li>
              <button
                class="flex items-center justify-center w-10 h-10 hover:bg-gray-100 dark:hover:bg-neutral-800 focus:outline-none focus-visible:ring-4 focus-visible:ring-gray-200 dark:focus-visible:ring-gray-700 rounded-lg p-2.5 mr-1 animated">
                <span class="material-symbols-outlined">
                  search
                </span>
              </button>
            </li>
            <li>
              <button @click="toggleTheme('light')" v-if="userStore?.user?.appearance === 'dark'"
                class="flex items-center justify-center w-10 h-10 hover:bg-gray-100 dark:hover:bg-neutral-800 focus:outline-none focus-visible:ring-4 focus-visible:ring-gray-200 dark:focus-visible:ring-gray-700 rounded-lg p-2.5 mr-1 animated">
                <span class="material-symbols-outlined">
                  light_mode
                </span>
              </button>
              <button @click="toggleTheme('dark')" v-if="userStore?.user?.appearance === 'light'"
                class="flex items-center justify-center w-10 h-10 hover:bg-gray-100 dark:hover:bg-neutral-800 focus:outline-none focus-visible:ring-4 focus-visible:ring-gray-200 dark:focus-visible:ring-gray-700 rounded-lg p-2.5 mr-1 animated">
                <span class="material-symbols-outlined">
                  dark_mode
                </span>
              </button>
            </li>
            <li>
              <button data-dropdown-toggle="accountMenu"
                class="flex items-center justify-center w-10 h-10 hover:bg-gray-100 dark:hover:bg-neutral-800 focus:outline-none focus-visible:ring-4 focus-visible:ring-gray-200 dark:focus-visible:ring-gray-700 rounded-lg p-2.5 mr-1 animated">
                <span class="material-symbols-outlined">
                  account_circle
                </span>
              </button>
              <div id="accountMenu"
                class="z-50 hidden bg-white divide-y divide-gray-200 rounded-lg shadow-sm w-44 dark:bg-neutral-900 dark:divide-neutral-800">
                <ul class="py-2" aria-labelledby="accountMenu">
                  <li>
                    <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-neutral-800">Settings</a>
                  </li>
                  <li>
                    <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-neutral-800">Help</a>
                  </li>
                </ul>
                <div class="py-2">
                  <a @click="handleLogout"
                    class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-neutral-800">Logout</a>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </nav>
    <div class="flex-1">
      <div class="container mx-auto px-4 md:px-0">
        <router-view />
      </div>
    </div>
  </div>
</template>
<script setup>
import { onMounted } from 'vue'
import { initDropdowns } from 'flowbite'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { showAlert } from '@/stores/alert'

const router = useRouter()
const userStore = useUserStore()

onMounted(() => {
  initDropdowns()
})

const handleLogout = async () => {
  await userStore.logout()
  showAlert('You’ve been logged out. See you again soon!', 'success')
  router.push('/sign_in')
}

const toggleTheme = async (theme) => {
  userStore.updateSettings({ appearance: theme })
  localStorage.setItem('theme', theme)
}
</script>
