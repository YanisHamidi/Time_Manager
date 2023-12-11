<script setup>
import Nav from './nav/Nav.vue'
import store from '../store/index'
import submitFormButton from '../components/button/submitFormButton.vue'
import submitDeleteButton from '../components/button/submitDeleteButton.vue'
import { showNotification } from '../components/notification/showNotifications'
import { deleteUser } from '../api/deleteUser'
import { updateUser } from '../api/updateUser'
import Route from '../router/index'
import { ref } from 'vue'

const usernameValue = ref('')
const emailValue = ref('')
const passwordValue = ref('')

const handleDeleteButton = async () => {
  const result = await deleteUser(store.state.user.id)
  if (result === 200) {
    store.dispatch('logout')
    localStorage.clear('token')
    Route.push('/')
  } else showNotification('Une erreur est survenue.', 'error')
}

const handleSubmitForm = async () => {
  const result = await updateUser(
    true,
    store.state.user.id,
    usernameValue.value,
    emailValue.value,
    passwordValue.value
  )
  if (result === true) {
    usernameValue.value = ''
    emailValue.value = ''
    passwordValue.value = ''
    showNotification('Votre profile a bien été mis à jour.', 'success')
  } else showNotification('Une erreur est survenue.', 'error')
}
</script>
<template>
  <header>
    <Nav />
  </header>
  <main class="flex flex-col items-center justify-center w-full">
    <div class="flex flex-col lg:w-[50%] w-[80%] bg-white py-8 px-10 rounded-xl mt-10 items-start">
      <h1 class="mb-10 text-xl font-semibold w-full text-left">Personal Informations</h1>
      <div class="flex flex-col mb-4 w-full">
        <label class="font-medium">Username</label>
        <input
          class="bg-zinc-50 py-2 px-2 rounded-md mb-2"
          :placeholder="store.state.user.username"
          type="text"
          v-model="usernameValue"
        />
        <label class="font-medium">Email</label>
        <input
          class="bg-zinc-50 py-2 px-2 rounded-md mb-2"
          :placeholder="store.state.user.email"
          type="text"
          v-model="emailValue"
        />
        <label class="font-medium">Mot de passe</label>
        <input
          class="bg-zinc-50 py-2 px-2 rounded-md"
          placeholder="*********"
          type="text"
          v-model="passwordValue"
        />
      </div>
      <submitFormButton message="Valider" @click="handleSubmitForm" />
    </div>
    <div
      class="flex flex-col lg:w-[50%] w-[80%] bg-white py-8 px-10 rounded-xl mt-10 items-start mb-4"
    >
      <h2 class="mb-10 text-xl font-semibold w-full text-left">Danger Zone</h2>
      <p class="text-sm mb-4">
        Deleting your account will permanently erase your profile, documents, and usage data, and
        the process is manual and can take up to 24 hours. Please note that recovery of any deleted
        information will not be possible.
      </p>
      <submitDeleteButton message="Delete My Account" @click="handleDeleteButton" />
    </div>
  </main>
</template>
