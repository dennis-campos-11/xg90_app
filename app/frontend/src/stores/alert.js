import { ref } from 'vue'

export const alert = ref({
  show: false,
  message: '',
  type: 'info'
})

let timeoutId = null

export function showAlert(message, type = 'info') {
  if (timeoutId) {
    clearTimeout(timeoutId)
    timeoutId = null
  }

  alert.value = {
    show: true,
    message,
    type
  }

  timeoutId = setTimeout(() => {
    alert.value.show = false
    timeoutId = null
  }, 10000)
}
