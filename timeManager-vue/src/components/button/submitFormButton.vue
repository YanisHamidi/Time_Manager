<script setup>
defineProps({
  message: String
})
</script>

<template>
  <button
    class="text-white rounded-xl px-10 font-semibold text-xl lg:text-sm py-2 bg-gradient-to-r from-cyan-300 to-blue-300 flex items-center justify-center"
  >
    {{ message }}
  </button>
</template>
