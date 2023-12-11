import axios from 'axios'

export const lastShift = async (userId) => {
  try {
    const response = await axios.get(`${import.meta.env.VITE_API_URL}api/workingtimes/${userId}`)
    if (response.status === 200) return response.data.data
  } catch (error) {
    console.log(error)
  }
}
