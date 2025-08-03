<template>
  <div class="relative">
    <button :id="`${id}-button`" :data-dropdown-toggle="`${id}-dropdown`" data-dropdown-placement="bottom-start"
      class="w-full border border-gray-200 hover:bg-gray-100 focus-visible:ring-4 focus:outline-none focus-visible:ring-gray-100 rounded-lg px-3 py-2 text-center flex items-center justify-between dark:focus-visible:ring-neutral-600 dark:hover:bg-neutral-900 dark:border-neutral-800 animated"
      type="button">
      <div class="flex">
        <div>{{ label }}</div>
        <div v-if="modelValue" class="font-medium">: {{ getSelectedLabel(modelValue) }}</div>
      </div>
      <span class="material-symbols-outlined">keyboard_arrow_down</span>
    </button>
    <div :id="`${id}-dropdown`"
      class="w-55 z-30 hidden bg-white border border-gray-200 divide-y divide-gray-200 rounded-lg shadow-sm dark:bg-neutral-900 dark:border-neutral-800 dark:divide-neutral-800">
      <ul class="p-3" :aria-labelledby="`${id}-button`">
        <li v-for="item in items" :key="`${id}-${item.id}`">
          <div class="flex items-center ps-2 rounded-sm hover:bg-gray-100 dark:hover:bg-neutral-800">
            <input type="radio" :id="`${id}-${item.id}`" :value="item.id" :name="id" v-model="internalValue"
              class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-neutral-800 focus:ring-2 dark:bg-neutral-700 dark:border-neutral-600">
            <label :for="`${id}-${item.id}`" class="w-full py-2 ms-2 rounded-sm">
              {{ getSelectedLabel(item.id) }}
            </label>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const props = defineProps({
  id: String,
  label: String,
  items: Array,
  modelValue: [String, Number, null],
  translateKey: String
})

const emit = defineEmits(['update:modelValue'])

const internalValue = ref(props.modelValue)

watch(internalValue, val => emit('update:modelValue', val))
watch(() => props.modelValue, val => internalValue.value = val)

function getSelectedLabel(id) {
  return props.translateKey
    ? t(`${props.translateKey}.${id}`)
    : props.items.find(item => item.id === id)?.name || id
}
</script>
