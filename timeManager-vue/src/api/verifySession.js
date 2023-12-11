import axios from 'axios'
import store from '../store/index'

export const verifySession = async (token) => {
  try {
    const response = await axios.post(`${import.meta.env.VITE_API_URL}api/users/verify_session`, token)
    if (response.status === 200) {
      store.commit('setUser', {
        id: response.data.data.id,
        username: response.data.data.username,
        email: response.data.data.email,
        role: response.data.data.role,
        society: response.data.data.society
      })
      return true
    } else {
      return false
    }
  } catch (error) {
    localStorage.removeItem('userToken')
    return false
  }
}
