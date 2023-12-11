import store from '../../store/index'
export const showNotification = (msg, notificationType) => {
  const isVisible = true
  store.dispatch('displayNotif', { message: msg, type: notificationType, isVisible })
  setTimeout(() => {
    store.dispatch('reset')
  }, 4000)
}
