import { loginUser } from '../api/loginUser'

export const pushConnection = async (email, password) => {
  if (email && password) {
    const response = await loginUser(email, password)
    return response
  } else return "Veuillez remplir tous les champs s'il vous plait"
}

export default pushConnection
