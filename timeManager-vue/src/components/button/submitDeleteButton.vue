<script setup>
defineProps({
  message: String
})
</script>

<template>
  <button
    class="text-white rounded-xl px-10 font-semibold text-xl lg:text-sm py-2 bg-red-600 flex items-center justify-center"
  >
    {{ message }}
  </button>
</template>
