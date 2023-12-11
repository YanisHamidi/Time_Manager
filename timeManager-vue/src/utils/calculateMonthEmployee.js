import { allWorkingTime } from '../api/getWorkingtimes'

export const calculateMonthEmployee = async () => {
  const today = new Date()
  const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1)

  const monthDateStart = new Date(lastMonth.getFullYear(), lastMonth.getMonth(), 1)
  const monthDateEnd = new Date(lastMonth.getFullYear(), lastMonth.getMonth() + 1, 0)

  try {
    const response = await allWorkingTime(null, monthDateStart, monthDateEnd)

    const userWorkTimeMap = {}

    for (let i = 0; i < response.data.length; i++) {
      const currentData = response.data[i]

      if (!Object.prototype.hasOwnProperty.call(userWorkTimeMap, currentData.username)) {
        userWorkTimeMap[currentData.username] = 0
      }

      userWorkTimeMap[currentData.username] += currentData.working_time_seconds
    }

    let maxWorkingTime = 0
    let usernameWithMaxWorkingTime = ''

    for (const username in userWorkTimeMap) {
      if (
        Object.prototype.hasOwnProperty.call(userWorkTimeMap, username) &&
        userWorkTimeMap[username] > maxWorkingTime
      ) {
        maxWorkingTime = userWorkTimeMap[username]
        usernameWithMaxWorkingTime = username
      }
    }

    return usernameWithMaxWorkingTime
  } catch (error) {
    console.log('Une erreur est survenue', error)
  }
}
