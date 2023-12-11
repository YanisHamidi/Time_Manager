import store from '../store/index'
import router from '../router/index'
import axios from 'axios'
export const loginUser = async (email, password) => {

  if (!email || !password) return false

  try {
    const response = await axios.post(
     `${import.meta.env.VITE_API_URL}api/users/sign_in` ,
      {
        email: email,
        password: password
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )
    if (response.status === 200) {
      store.commit('setUser', {
        id: response.data.data.id,
        username: response.data.data.username,
        email: response.data.data.email,
        role: response.data.data.role,
        society: response.data.data.society
      })
      localStorage.setItem('userToken', JSON.stringify({ token: response.data.data.token }))
      router.push('/dashboard')
    } else return 'Une erreur est surevenue lors de la connexion veuillez réessayer plus tard.'
  } catch (error) {
    return error.response.data.error
  }
}
