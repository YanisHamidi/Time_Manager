import axios from 'axios'

export const getUser = async () => {
  try {
    const response = await axios.get(`${import.meta.env.VITE_API_URL}api/users`)
    if (response.status === 200) {
      return response
    }
  } catch (error) {
    console.error(error)
  }
}
