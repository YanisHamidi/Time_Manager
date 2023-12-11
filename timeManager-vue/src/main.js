import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store/index'
import axios from 'axios'

axios.interceptors.request.use((config) => {
  const authToken = JSON.parse(localStorage.getItem('userToken'))
  if (authToken) {
    config.headers.Authorization = `Bearer ${authToken.token}`
  } else {
    delete config.headers.Authorization
  }
  return config
})

const app = createApp(App)

app.use(router)
app.use(store)

app.mount('#app')
