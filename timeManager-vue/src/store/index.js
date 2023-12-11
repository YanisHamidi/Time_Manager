import { createStore } from 'vuex'

const store = createStore({
  state: {
    user: {
      id: null,
      username: null,
      email: null,
      role: null,
      society: null
    },
    notif: {
      message: null,
      type: null,
      isVisible: false
    }
  },
  mutations: {
    setUser(state, { id, username, email, role, society }) {
      state.user.id = id
      state.user.username = username
      state.user.email = email
      state.user.role = role
      state.user.society = society
    },
    setNotif(state, { message, type, isVisible }) {
      state.notif.message = message
      state.notif.type = type
      state.notif.isVisible = isVisible
    }
  },
  actions: {
    login(context, { id, username, email, role, society }) {
      context.commit('setUser', { id, username, email, role, society })
    },
    logout(context) {
      context.commit('setUser', {
        id: null,
        username: null,
        email: null,
        role: null,
        society: null
      })
    },
    displayNotif(context, { message, type, isVisible }) {
      context.commit('setNotif', { message, type, isVisible })
    },
    reset(context) {
      context.commit('setNotif', {
        message: null,
        type: null,
        isVisible: false
      })
    }
  },
  getters: {
    isAuthenticated: (state) => state.user.id !== null,
    getUserInfo: (state) => state.user
  }
})

export default store
