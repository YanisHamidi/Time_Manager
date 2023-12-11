import axios from 'axios'

export const deleteUser = async (userId) => {
  try {
    const response = await axios.delete(`${import.meta.env.VITE_API_URL}api/users/${userId}`)
    if (response.status === 200) return response.status
  } catch (error) {
    return 'Une erreur est survenue'
  }
}
