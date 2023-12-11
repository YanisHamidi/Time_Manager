function secondsToHours(seconds) {
  let hours = Math.floor(seconds / 3600)
  let remainingMinutes = Math.floor((seconds % 3600) / 60)
  let remainingSeconds = seconds % 60
  if (remainingMinutes < 10) remainingMinutes = '0' + remainingMinutes
  if (remainingSeconds < 10) remainingSeconds = '0' + remainingSeconds

  return {
    hours: hours,
    minutes: remainingMinutes,
    seconds: remainingSeconds
  }
}
export const addHours = (workingtimes) => {
  let secondes = 0
  if (workingtimes) {
    for (var i = 0; i < workingtimes.data.length; i++) {
      secondes += workingtimes.data[i].working_time_seconds
    }
  }
  return secondsToHours(secondes)
}

export const secondsToHoursData = (seconds) => {
  let hours = Math.floor(seconds / 3600)
  let minutes = Math.floor((seconds % 3600) / 60)
  minutes /= 60
  return hours + minutes
}
