<script setup>
import Nav from './nav/Nav.vue'
import store from '../store/index'
import { Users, Clock } from 'lucide-vue-next'
import { getUser } from '../api/getUser'
import { countEntryArray } from '../utils/countArray'
import { allWorkingTime } from '../api/getWorkingtimes'
import { calculateMonthEmployee } from '../utils/calculateMonthEmployee'
import { Star } from 'lucide-vue-next'
import VueDatePicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'
import { ref, onMounted } from 'vue'
import apexchart from '../components/charts/chartsVue.vue'
import { addHours } from '../utils/addHours'

//Variables pour premier bloc de stats
let users = null
let hoursOnMonth = ref(null)
let totalEmployee = ref(null)
let monthEmployee = ref(null)

//Variables pour chart
let date = ref()
let key = ref(0)
let userIdCharts = ref(null)

//Fonction pour chart
const updateUserChart = () => {
  key.value++
}

const dateClicked = (newDate) => {
  if (date.value) {
    const startDate = new Date(newDate[0])
    const endDate = new Date(newDate[1])
    date.value = [startDate, endDate]
    key.value++
  }
}

onMounted(async () => {
  //Date de base pour Chart
  const startDate = new Date()
  const endDate = new Date(new Date().setDate(startDate.getDate() + 7))
  date.value = [startDate, endDate]

  // const lastMonthDate = new Date(new Date().setMonth(startDate.getMonth() - 1))
  hoursOnMonth.value = await addHours(
    await allWorkingTime(new Date(new Date().setDate(1)), new Date(new Date().setDate(31)))
  )

  monthEmployee.value = await calculateMonthEmployee()
  users = await getUser()
  totalEmployee.value = await countEntryArray(users.data)
})
</script>

<template>
  <main class="w-full flex flex-col items-center relative">
    <header class="w-full mb-8">
      <Nav />
    </header>
    <div class="w-[80%] mb-10">
      <span class="font-medium text-xl">Bonjour {{ store.state.user.username }}</span>
      <div class="lg:flex justify-between mt-6">
        <div
          class="lg:w-[31%] py-4 px-6 text-center rounded-lg bg-white mb-4 lg:mb-0 flex flex-col items-center justify-center"
        >
          <span v-if="totalEmployee" class="font-medium">{{ totalEmployee }}</span>
          <hr class="w-[70%] my-2" />
          <span class="font-medium text-sm flex items-center text-gray-400">
            <Users class="w-4 mr-2" />Employees</span
          >
        </div>
        <div
          class="lg:w-[31%] py-4 px-6 text-center rounded-lg bg-white mb-4 lg:mb-0 flex flex-col items-center justify-center"
        >
          <span v-if="hoursOnMonth" class="font-medium">{{ hoursOnMonth.hours }} Hours</span>
          <hr class="w-[70%] my-2" />
          <span class="font-medium text-sm flex items-center text-gray-400">
            <Clock class="w-4 mr-2" />This month</span
          >
        </div>
        <div
          class="lg:w-[31%] py-4 px-6 text-center rounded-lg bg-white flex flex-col items-center justify-center"
        >
          <span v-if="monthEmployee" class="font-medium">{{ monthEmployee }}</span>
          <hr class="w-[70%] my-2" />
          <span class="font-medium text-sm flex items-center text-gray-400">
            <Star class="w-4 mr-2" />Month employee
          </span>
        </div>
      </div>
    </div>
    <div class="w-[80%]">
      <span class="font-medium text-xl">Statistiques</span>
      <div class="lg:w-fit mt-6 lg:flex">
        <VueDatePicker
          range
          :enable-time-picker="false"
          :model-value="date"
          @update:model-value="dateClicked"
        />
        <select
          v-if="users"
          class="ml-2 px-4 rounded bg-white border-[1px] border-[#ddd]"
          v-model="userIdCharts"
          @change="updateUserChart(userIdCharts)"
        >
          >
          <option :value="null">All</option>
          <option v-for="user in users.data.data" :key="user.id" :value="user.id">
            {{ user.username }}
          </option>
        </select>
      </div>

      <div :key="key" class="w-full">
        <apexchart v-if="date" :dateData="date" :userId="userIdCharts" />
      </div>
    </div>
  </main>
</template>
