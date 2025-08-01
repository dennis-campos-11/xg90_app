import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import 'vue3-flag-icons/styles'
import i18n from './i18n'

import App from './App.vue'
import router from './router'

import 'flowbite'
import '@vueform/slider/themes/default.css'

const app = createApp(App)

app.use(createPinia())
app.use(i18n)
app.use(router)

app.mount('#app')
