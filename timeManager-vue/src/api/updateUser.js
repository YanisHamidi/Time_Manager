import axios from 'axios'
import { isEmailValid } from '../utils/isEmailValid'
import store from '../store/index'

export const updateUser = async (selfChange, userId, username, email, password, role) => {
  const userRequest = { user: {} }
  if (email) {
    if (!isEmailValid(email)) return 'Veuillez entrer une adresse mail valide'
  }
  if (role) userRequest.user.role = role
  if (username) userRequest.user.username = username
  if (email) userRequest.user.email = email
  if (password) userRequest.user.password = password
  try {
    const response = await axios.patch(`${import.meta.env.VITE_API_URL}api/users/${userId}`, userRequest)
    if (response.status === 200) {
      if (selfChange === true) {
        if (role) store.state.user.role = role
        if (email) store.state.user.email = email
        if (username) store.state.user.username = username
      }
      return true
    }
  } catch (error) {
    return 'Une erreur est survenue'
  }
}
