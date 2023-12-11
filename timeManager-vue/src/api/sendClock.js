import axios from 'axios'

export const lastClock = async (userId) => {
  if (!userId) return null
  try {
    const response = await axios.get(`${import.meta.env.VITE_API_URL}api/clocks/${userId}`)
    if (response.status === 200) return response.data.data
    else if (response.status === 204) return false
  } catch (error) {
    return 'Une erreur est survenue veuillez réessayer plus tard ou contacter le service client'
  }
}

export const sendClocks = async (userId, type) => {
  if (!userId) return 'Une erreur est survenue veuillez contacter le service client.'
  try {
    const response = await axios.post(
      `${import.meta.env.VITE_API_URL}api/clocks/${userId}`,
      {
        clock: {
          status: !type
        }
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )
    if (response.status === 201) {
      if (!type === false) return 'Fin du shift'
      else return 'Début du shift'
    }
  } catch (error) {
    console.log('Error', error)
  }
}
