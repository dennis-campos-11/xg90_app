export function buildNestedAttributes(payload, nestedKeys) {
  const result = structuredClone(payload)

  nestedKeys.forEach((key) => {
    if (result[key]) {
      result[`${key}_attributes`] = result[key]
      delete result[key]
    }
  })

  return result
}