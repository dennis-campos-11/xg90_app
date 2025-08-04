<template>
  <tr class="border-b border-gray-200 dark:border-neutral-800 hidden">
    <td></td>
    <td class="px-3 min-w-22 max-w-22 h-12 font-medium whitespace-nowrap sticky left-0 z-10 bg-inherit"
      :class="{ 'right-shadow': hasScrolled }">
      <div class="flex items-center w-45">
        <img :src="getCompetitionLogo(competition.id)" class="inline w-7 h-7 mr-2" />
        <div class="truncate" :title="competition.name">{{ competition.name }}</div>
      </div>
    </td>
  </tr>
</template>

<script setup>

defineProps({
  competition: Object,
  hasScrolled: Boolean
})

function getCompetitionLogo(competitionId) {
  return `http://localhost:3000/competitions/${competitionId}.png` // ajusta según tu estructura real
}
</script>