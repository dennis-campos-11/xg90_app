export function useComparison() {
  const formatDifference = (teamValue, competitionValue) => {
    const baseClass = 'text-sm'

    if (teamValue == null || competitionValue == null || competitionValue === 0) {
      return { text: '-', class: baseClass }
    }

    const diff = ((teamValue - competitionValue) / competitionValue) * 100
    const diff_rounded = Math.round(diff * 100) / 100
    const opacity = diff > 100 ? 100 : Math.abs(Math.round(diff))

    const colorClass = diff > 0 ? `text-emerald-700` : diff < 0 ? `text-red-700` : ''

    return {
      text: `${diff_rounded > 0 ? '+' : ''}${diff_rounded}%`,
      class: `${baseClass} ${colorClass}/${opacity}`,
    }
  }

  const cellFormat = (teamValue, opponentValue) => {
    const maxValue = (opponentValue == null) ? 100 : Math.max(teamValue, opponentValue)

    if (opponentValue === 0) {
      return { class: null }
    }

    const rate = (teamValue / maxValue) * 100
    const opacity = rate > 100 ? 100 : Math.abs(Math.round(rate))
    const colorClass = `bg-scale-${opacity}`

    return {
      class: `${colorClass} text-black`,
    }
  }

  const bestValue = (teamValue, opponentValue) => {
    const baseClass = ''

    const cssClass = teamValue > opponentValue ? 'font-medium dark:text-neutral-200' : 'font-normal'

    return {
      class: `${baseClass} ${cssClass}`,
    }
  }

  return { formatDifference, cellFormat, bestValue }
}
