import { createRouter, createWebHistory } from 'vue-router'
import { verifySession } from '../api/verifySession'
import UserVue from '../components/UserVue.vue'
import UserConnection from '../components/connectionUser/UserConnection.vue'
import UserRegister from '../components/connectionUser/UserRegister.vue'
import HomeVue from '../components/HomeVue.vue'
import HomeVueManager from '../components/HomeVueAdmin.vue'
import AccountVue from '../components/AccountVue.vue'
import SettingsVue from '../components/SettingsVue.vue'
import store from '../store/index'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: UserVue
    },
    {
      path: '/connection',
      name: 'connexion',
      component: UserConnection
    },
    {
      path: '/register',
      name: 'register',
      component: UserRegister
    },
    {
      path: '/dashboard',
      name: 'Dashboad',
      component: HomeVue
    },
    {
      path: '/dashboardManager',
      name: 'dashboardManager',
      component: HomeVueManager
    },
    {
      path: '/account',
      name: 'account',
      component: AccountVue
    },
    {
      path: '/settings',
      name: 'settings',
      component: SettingsVue
    }
  ]
})

router.beforeEach(async (to, from, next) => {
  const token = JSON.parse(localStorage.getItem('userToken'))
  if (token && store.state.user.email == null) {
    try {
      await verifySession(token)
      next('/dashboard')
    } catch (error) {
      console.log(error)
      next('/')
    }
  } else if (
    to.path != '/' &&
    to.path != '/connection' &&
    to.path != '/register' &&
    store.state.user.email == null &&
    !localStorage.getItem('token')
  ) {
    next('/')
  } else if (
    (to.path == '/' || to.path == '/connection' || to.path == '/register') &&
    store.state.user.email != null
  ) {
    next('/dashboard')
  } else {
    next()
  }
})

export default router
