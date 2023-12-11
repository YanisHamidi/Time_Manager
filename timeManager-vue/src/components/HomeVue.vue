<script setup>
import Nav from './nav/Nav.vue'
import store from '../store/index'
import { showNotification } from './notification/showNotifications'
import { addHours } from '../utils/addHours'
import { formatDate } from '../utils/formatDate'
import { todayWorkingtimesByUid, workingtimeWeekByUid } from '../api/getWorkingtimes'
import { RotateCw, Clock, CalendarCheck2, Power } from 'lucide-vue-next'
import { sendClocks, lastClock } from '../api/sendClock'
import { onBeforeMount, ref } from 'vue'

let lastClockUser = null
let hoursWorkToday = ref(null)
let lastActivity = ref(null)
let workThisWeek = ref(null)

const lastActivityRefresh = async () => {
  let response = await lastClock(store.state.user.id)
  response = formatDate(response.time)
  return response
}

const hoursWorkUserToday = async () => {
  let response = await todayWorkingtimesByUid(store.state.user.id)
  response = addHours(response)
  return response
}

const handleClockClickButton = async () => {
  lastClockUser = await lastClock(store.state.user.id)
  const response = await sendClocks(store.state.user.id, lastClockUser.status)
  if (response) {
    lastActivity.value = await lastActivityRefresh()
    hoursWorkToday.value = await hoursWorkUserToday()
    showNotification(response, 'success')
  }
}

onBeforeMount(async () => {
  hoursWorkToday.value = await hoursWorkUserToday()
  lastActivity.value = await lastActivityRefresh()
  workThisWeek.value = await workingtimeWeekByUid(store.state.user.id)
})
</script>

<template>
  <main class="w-full flex flex-col items-center h-screen relative">
    <header class="w-full mb-8">
      <Nav />
    </header>
    <div class="w-[80%] mb-10">
      <span class="font-medium text-xl">Bonjour {{ store.state.user.username }}</span>
      <div class="lg:flex justify-between mt-6">
        <div
          class="lg:w-[31%] py-4 px-6 text-center rounded-lg bg-white mb-4 lg:mb-0 flex flex-col items-center justify-center"
        >
          <span v-if="lastActivity" class="font-medium">{{ lastActivity }}</span>
          <hr class="w-[70%] my-2" />
          <span class="font-medium text-sm flex items-center text-gray-400">
            <RotateCw class="w-4 mr-2" />last activity</span
          >
        </div>
        <div
          class="lg:w-[31%] py-4 px-6 text-center rounded-lg bg-white mb-4 lg:mb-0 flex flex-col items-center justify-center"
        >
          <span v-if="workThisWeek" class="font-medium">{{
            workThisWeek.hours + ':' + workThisWeek.minutes
          }}</span>
          <hr class="w-[70%] my-2" />
          <span class="font-medium text-sm flex items-center text-gray-400">
            <Clock class="w-4 mr-2" />This week</span
          >
        </div>
        <div
          class="lg:w-[31%] py-4 px-6 text-center rounded-lg bg-white flex flex-col items-center justify-center"
        >
          <span class="font-medium">10 Days</span>
          <hr class="w-[70%] my-2" />
          <span class="font-medium text-sm flex items-center text-gray-400">
            <CalendarCheck2 class="w-4 mr-2" />Available day off
          </span>
        </div>
      </div>
    </div>
    <div class="w-full flex flex-col items-center justify-center">
      <button @click="handleClockClickButton" class="mb-4">
        <Power class="text-gray-400 stroke-2 w-40 h-40" />
      </button>
      <span class="font-medium text-sm flex items-center text-gray-400" v-if="hoursWorkToday">{{
        hoursWorkToday.hours +
        ':' +
        hoursWorkToday.minutes +
        ':' +
        hoursWorkToday.seconds +
        ' today'
      }}</span>
    </div>
  </main>
</template>
