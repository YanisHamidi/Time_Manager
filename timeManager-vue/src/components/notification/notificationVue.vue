<script setup>
import { Ban, Check } from 'lucide-vue-next'
import store from '../../store/index.js'
</script>
<template>
  <div
    v-if="store.state.notif.isVisible"
    class="absolute z-20 flex py-3 px-4 w-[30%] left-[35%] rounded-lg bg-white top-[12%] items-center drop-shadow-lg transition-all"
  >
    <span class="text-white bg-black rounded-full p-1">
      <Check class="w-4 h-4" v-if="store.state.notif.type === 'success'" />
      <Ban class="w-4 h-4" v-if="store.state.notif.type === 'error'" />
    </span>
    <span class="ml-4 font-medium text-sm">{{ store.state.notif.message }}</span>
  </div>
</template>
