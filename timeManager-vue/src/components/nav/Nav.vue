<script setup>
import { RouterLink } from 'vue-router'
import store from '../../store/index'
import route from '../../router/index'
import { ref } from 'vue'
import { Menu, Settings, X, UserPlus2, BarChart3 } from 'lucide-vue-next'
import { User2 } from 'lucide-vue-next'
import { LogOut } from 'lucide-vue-next'

const role = store.state.user.role
const isMenuHidden = ref(true)
const isRoute = route.currentRoute.value.fullPath

const handleMenuClickButton = () => {
  isMenuHidden.value = !isMenuHidden.value
}

const handleLogoutClickButton = () => {
  store.dispatch('logout')
  localStorage.clear('token')
  route.push('/')
}
</script>

<template>
  <div class="w-full border-b-[1px] border-gray-200 flex flex-col items-center bg-white">
    <div class="w-[80%] flex justify-between top-[2%] py-6">
      <RouterLink to="/dashboard">
        <span class="font-bold text-2xl">Time</span>
        <span class="font-regular text-2xl">Manager</span>
      </RouterLink>
      <button @click="handleMenuClickButton"><Menu /></button>
    </div>
    <nav
      class="w-full flex flex-col top-0 z-10 rounded-2xl bg-white py-6 px-6"
      :class="{ hidden: isMenuHidden, absolute: !isMenuHidden }"
    >
      <div class="flex justify-between items-center mb-4">
        <span class="text-xl font-semibold">Menu</span>
        <span class="text-md font-medium flex"
          ><User2 class="mr-2" />{{ store.state.user.username }}</span
        >
        <button @click="handleMenuClickButton"><X /></button>
      </div>
      <RouterLink
        class="w-full flex items-center text-lg font-medium py-3 px-6 hover:bg-zinc-100 rounded-lg mb-2"
        :class="{ 'bg-zinc-100': isRoute === '/settings' }"
        to="/settings"
      >
        <Settings class="mr-2" />
        Settings
      </RouterLink>
      <RouterLink
        v-if="role !== 'Employee'"
        class="w-full flex items-center text-lg font-medium py-3 px-6 hover:bg-zinc-100 rounded-lg mb-2"
        :class="{ 'bg-zinc-100': isRoute === '/account' }"
        to="/account"
      >
        <UserPlus2 class="mr-2" />
        Comptes
      </RouterLink>
      <RouterLink
        v-if="role !== 'Employee'"
        class="w-full flex items-center text-lg font-medium py-3 px-6 hover:bg-zinc-100 rounded-lg mb-2"
        :class="{ 'bg-zinc-100': isRoute === '/dashboardManager' }"
        to="/dashboardManager"
      >
        <BarChart3 class="mr-2" />
        Manager Dashboard
      </RouterLink>
      <button
        class="w-full flex items-center text-lg font-medium py-3 px-6 hover:bg-red-500 hover:text-white rounded-lg"
        @click="handleLogoutClickButton"
      >
        <LogOut class="mr-2" />
        Deconnexion
      </button>
    </nav>
  </div>
</template>
