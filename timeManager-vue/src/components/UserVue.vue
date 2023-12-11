<script setup>
import { RouterLink } from 'vue-router'
</script>

<template>
  <main class="w-full flex flex-col items-center justify-center h-screen relative">
    <div class="absolute top-[8%] left-[5%]">
      <span class="font-bold text-3xl">Time</span>
      <span class="font-regular text-3xl">Manager</span>
    </div>
    <img
      src="../assets/homeIllustration.svg"
      alt="Image de presentation"
      class="lg:w-[30%] mb-[30%] mt-[50%] lg:mt-[10%] lg:mb-[10%]"
    />
    <p class="w-85 text-center font-medium text-3xl mb-6">
      Manager
      <span class="font-bold text-[#A1E1FC]">Votre equipe</span>
      en toute simplicité
    </p>
    <RouterLink
      class="text-white rounded-full w-80 py-3 mb-2 text-2xl bg-gradient-to-r from-cyan-300 to-blue-300 flex items-center justify-center"
      to="/connection"
    >
      Se connecter
    </RouterLink>
    <span
      >Pas encore de compte ?
      <RouterLink to="/register" class="font-bold text-[#A1E1FC] cursor-pointer"
        >Inscription</RouterLink
      ></span
    >
  </main>
</template>
