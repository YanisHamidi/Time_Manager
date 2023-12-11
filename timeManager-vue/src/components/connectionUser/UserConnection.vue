<script setup>
import { ref } from 'vue'
import submitFormButton from '../button/submitFormButton.vue'
import { RouterLink } from 'vue-router'
import pushConnection from '../../utils/connectionUtils'

const emailValue = ref('')
const passwordValue = ref('')

const handleButtonClick = async () => {
  const response = await pushConnection(emailValue.value, passwordValue.value)
  if (response) alert(response)
}
</script>

<template>
  <main class="w-100 flex flex-col items-center justify-center h-screen relative">
    <img
      src="../../assets/pathIllustrationTop.svg"
      alt="Forme géometrique décorative"
      class="absolute top-0 w-full lg:hidden"
    />
    <RouterLink class="absolute top-[8%] left-[5%]" to="/">
      <span class="font-bold text-3xl">Time</span>
      <span class="font-regular text-3xl">Manager</span>
    </RouterLink>
    <div class="w-80 text-center mb-16 z-10">
      <h1 class="text-4xl font-bold mb-2">Bienvenue</h1>
      <span class="font-medium">Connectez-vous à votre compte</span>
    </div>
    <div class="w-80 flex flex-col mb-6">
      <label class="font-medium">Email</label>
      <input
        type="text"
        name="email"
        placeholder="Exemple@exemple.com"
        class="bg-white py-2 px-2 rounded-md mb-2"
        v-model="emailValue"
      />
      <label class="font-medium">Mot de passe</label>
      <input
        type="password"
        name="password"
        placeholder="Votre mot de passe"
        class="bg-white py-2 px-2 rounded-md"
        v-model="passwordValue"
      />
    </div>
    <submitFormButton message="Se connecter" @click="handleButtonClick" />
    <img
      src="../../assets/pathIllustrationBottom.svg"
      alt="Forme géometrique décorative"
      class="absolute bottom-0 w-full lg:hidden"
    />
  </main>
</template>
