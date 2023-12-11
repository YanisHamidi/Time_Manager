import axios from 'axios'
import store from '../store/index'
import router from '../router/index'
import sendEmail from './sendEmail'

function randomPassword(maxLenght) {
  const allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*'

  let password = ''

  while (password.length < maxLenght) {
    const randomChar = allowedChars[Math.floor(Math.random() * allowedChars.length)]
    password += randomChar
  }
  return password
}

export const createUserGeneralManager = async (username, email, password, society) => {
  try {
    const response = await axios.post(
      `${import.meta.env.VITE_API_URL}api/users/sign_up`,
      {
        user: {
          username: username,
          email: email,
          password: password,
          role: 'GeneralManager',
          society: society
        }
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )

    if (response.status === 201) {
      store.commit('setUser', {
        id: response.data.data.id,
        username: response.data.data.username,
        email: response.data.data.email,
        role: response.data.data.role,
        society: response.data.data.society
      })
      localStorage.setItem('userToken', JSON.stringify({ token: response.data.data.token }))
      router.push('/dashboard')
    } else {
      console.error("Erreur lors de la création de l'utilisateur", response.status, response.data)
      // Gérez l'erreur de manière appropriée.
    }
  } catch (error) {
    console.error("Une erreur s'est produite lors de la requête API", error)
    return 'Une erreur est survenue veuillez réessayer plus tard ou contacter le service client.'
  }
}

export const createUserManager = async (username, email) => {
  const password = randomPassword(10)
  const message =
    'Bonjour, <br>' +
    store.state.user.email +
    ' vous a ajouté à son équipe sur TimeManager <br> Veuillez prendre connaissance de vos identifiants : <br> Email: ' +
    email +
    '<br> Mot de passe: ' +
    password

  try {
    const response = await axios.post(
      `${import.meta.env.VITE_API_URL}api/users`,
      {
        user: {
          username: username,
          email: email,
          password: password,
          role: 'Manager',
          society: store.state.user.society
        }
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )

    if (response.status === 201) {
      const responseEmail = await sendEmail(
        username,
        email,
        'Vos identifiants TimeManager',
        message
      )
      if (responseEmail === false) return "Une erreur est survenue lors de l'envoie de l'email"
      else return response
    } else {
      console.error("Erreur lors de la création de l'utilisateur", response.status, response.data)
      ;("Une erreur est surevenue lors de la création de l'utilisateur, veuillez réessayer plus tard ou contacter le service client.")
    }
  } catch (error) {
    console.error("Une erreur s'est produite lors de la requête API", error)
    return 'Une erreur est survenue veuillez réessayer plus tard ou contacter le service client.'
  }
}

export const createUserEmployee = async (username, email) => {
  const password = randomPassword(10)
  const message =
    'Bonjour, ' +
    store.state.user.email +
    ' vous a ajouté à son équipe sur TimeManager <br> Veuillez prendre connaissance de vos identifiants : <br> Email: ' +
    email +
    '<br> Mot de passe: ' +
    password
  try {
    const response = await axios.post(
      `${import.meta.env.VITE_API_URL}api/users` ,
      {
        user: {
          username: username,
          email: email,
          password: password,
          role: 'Employee',
          society: store.state.user.society
        }
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )

    if (response.status === 201) {
      const responseEmail = await sendEmail(
        username,
        email,
        'Vos identifiants TimeManager',
        message
      )
      if (responseEmail === false) return "Une erreur est survenue lors de l'envoie de l'email"
      else return response
    } else {
      console.error("Erreur lors de la création de l'utilisateur", response.status, response.data)
      ;("Une erreur est surevenue lors de la création de l'utilisateur, veuillez réessayer plus tard ou contacter le service client.")
    }
  } catch (error) {
    console.error("Une erreur s'est produite lors de la requête API", error)
    return 'Une erreur est survenue veuillez réessayer plus tard ou contacter le service client.'
  }
}
