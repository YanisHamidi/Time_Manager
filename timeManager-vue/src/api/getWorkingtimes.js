import axios from 'axios'
import { formatDateApi } from '../utils/formatDate'
import { addHours } from '../utils/addHours'

export const todayWorkingtimesByUid = async (userId) => {
  const startDate = formatDateApi(new Date())
  try {
    const response = await axios.get(
      `${import.meta.env.VITE_API_URL}api/workingtimes/${userId}?start_date=${startDate}&end_date=${startDate}`
    )
    if (response.status === 200) return response.data
  } catch (error) {
    console.log('Une erreur est survenue', error)
  }
}

export const workingtimeWeekByUid = async (userId) => {
  let todayDate = new Date()
  const jour = todayDate.getDay()
  let mondayDate = new Date(todayDate)
  mondayDate.setDate(todayDate.getDate() - jour + (jour === 0 ? -6 : 1))
  mondayDate = formatDateApi(mondayDate)
  todayDate = formatDateApi(todayDate)
  try {
    const response = await axios.get(
      `${import.meta.env.VITE_API_URL}api/workingtimes/${userId}?start_date=${mondayDate}&end_date=${todayDate}`
    )
    if (response.status === 200) {
      if (response.data === null) return 0
      else return addHours(response.data)
    }
  } catch (error) {
    console.log('Une erreur est survenue', error)
  }
}

export const allWorkingTime = async (userId, startDate, endDate) => {
  if (startDate) startDate = formatDateApi(startDate)
  if (endDate) endDate = formatDateApi(endDate)
  try {
    const response = await axios.get(
      `${import.meta.env.VITE_API_URL}api/workingtimes/${
        userId ? userId + '?' : '?'
      }start_date=${startDate}&end_date=${endDate}`
    )
    if (response.status === 200) return response.data
  } catch (error) {
    console.log('Une erreur est survenue', error)
  }
}
