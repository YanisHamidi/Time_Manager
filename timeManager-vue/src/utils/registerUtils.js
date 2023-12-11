import { createUserGeneralManager } from '../api/createUser'
import { isEmailValid } from './isEmailValid'

export const pushRegister = async (username, email, password, confirmPassword, society) => {
  if (username && email && password && confirmPassword && society) {
    if (isEmailValid(email)) {
      if (password == confirmPassword) {
        const result = await createUserGeneralManager(username, email, password, society)
        if (result) return result
      } else return 'Erreur les mot de passe ne correspondent pas'
    } else return 'Veuillez entrer une email valide !'
  } else return "Veuillez remplir tous les champs s'il vous plait !"
}

export default pushRegister
