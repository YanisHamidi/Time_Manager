<script setup>
import Nav from './nav/Nav.vue'
import submitFormButton from './button/submitFormButton.vue'
import store from '../store/index'
import { showNotification } from '../components/notification/showNotifications'
import { ref, onMounted } from 'vue'
import { createUserManager, createUserEmployee } from '../api/createUser'
import { X } from 'lucide-vue-next'
import { getUser } from '../api/getUser'
import { deleteUser } from '../api/deleteUser'
import { updateUser } from '../api/updateUser'

const usernameValue = ref('')
const emailValue = ref('')
const items = ref([])
let optionsRole = ref(['GeneralManager', 'Manager', 'Employee'])
let userResponse = null

const handleButtonClick = async () => {
  if (store.state.user.role === 'GeneralManager')
    userResponse = await createUserManager(usernameValue.value, emailValue.value)
  else userResponse = await createUserEmployee(usernameValue.value, emailValue.value)
  if (userResponse.status === 201) {
    showNotification('Le compte a bien été créé', 'success')
    let newUser = {
      id: userResponse.data.data.id,
      username: userResponse.data.data.username,
      role: 'Manager'
    }
    items.value.push(newUser)
  } else {
    showNotification(userResponse, 'error')
  }
}

const handleDeleteButtonClick = async (id) => {
  const response = await deleteUser(id)
  const indexToRemove = items.value.findIndex((item) => item.id === id)
  if (response === 200) {
    if (indexToRemove !== -1) items.value.splice(indexToRemove, 1)
    showNotification('Le compte a bien été supprimé', 'success')
  }
}

const handleChangeRole = async (id, role) => {
  const response = await updateUser(false, id, null, null, null, role)
  if (response === true) {
    showNotification('Le rôle a bien été changé', 'success')
  } else {
    showNotification("Une erreur est survenue, vous n'avez peut être pas les droits.", 'error')
  }
}

onMounted(() => {
  getUser()
    .then((response) => {
      items.value = response.data.data.map((item) => ({
        ...item,
        role: item.role || ''
      }))
      const indexToRemove = items.value.findIndex((item) => item.id === store.state.user.id)
      items.value.splice(indexToRemove, 1)
    })
    .catch((error) => {
      console.error(error)
    })
})
</script>

<template>
  <notificationVue :message="notificationMessage" v-if="showNotification" />
  <header>
    <Nav />
  </header>
  <main class="w-full flex flex-col items-center">
    <div class="mt-[2%] bg-white rounded-xl py-8 px-6 mb-[2%] lg:w-[50%] w-[80%]">
      <h1 class="mb-10 text-xl font-semibold">Ajouter un compte</h1>
      <div class="flex flex-col mb-2">
        <label class="font-medium">Username</label>
        <input
          type="text"
          name="email"
          placeholder="sebitoshow"
          class="bg-zinc-50 py-2 px-2 rounded-md mb-2 w-full"
          v-model="usernameValue"
        />
        <label class="font-medium">Email</label>
        <input
          type="text"
          name="email"
          placeholder="Exemple@exemple.com"
          class="bg-zinc-50 py-2 px-2 rounded-md mb-4 w-full"
          v-model="emailValue"
        />
        <submitFormButton message="Ajouter" @click="handleButtonClick" class="w-fit" />
      </div>
    </div>

    <div class="lg:w-[50%] w-[80%] bg-white py-6 px-4 rounded-lg max-h-[30%] overflow-y-auto mb-10">
      <h3 class="text-md mb-4">
        Utilisateurs de <span class="font-semibold">{{ store.state.user.society }}</span>
      </h3>
      <li
        v-for="item in items"
        :key="item.id"
        class="list-none flex items-center justify-between py-2 px-4 rounded-xl bg-zinc-50 mb-4"
      >
        <span
          >{{ item.username }}
          <select
            class="py-1 px-1 rounded-lg ml-2"
            v-model="item.role"
            v-if="store.state.user.role === 'GeneralManager'"
            @change="handleChangeRole(item.id, item.role)"
          >
            <option v-for="role in optionsRole" :value="role" :key="role" v-if="role !== item.role">
              {{ role }}
            </option>
          </select>
        </span>
        <button
          @click="handleDeleteButtonClick(item.id)"
          class="bg-red-500 rounded-full p-1"
          v-if="store.state.user.role === 'GeneralManager'"
        >
          <X class="text-white" />
        </button>
      </li>
    </div>
  </main>
</template>
