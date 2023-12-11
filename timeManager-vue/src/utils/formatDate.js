export const formatDate = (dateTime) => {
  const date = new Date(dateTime)
  const year = date.getFullYear()
  const month = date.getMonth() + 1
  let day = date.getDate()
  if (day < 10) day = '0' + day
  return day + '/' + month + '/' + year
}

export const formatDateApi = (dateTime) => {
  let startDay = dateTime.getDate()
  if (startDay < 10) startDay = '0' + startDay
  return dateTime.getFullYear() + '-' + (dateTime.getMonth() + 1) + '-' + startDay
}
