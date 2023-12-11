export const countEntryArray = async (array) => {
  let count = 0
  for (var i = 0; i < array.data.length; i++) {
    count++
  }
  return count
}
