<script>
import VueApexCharts from 'vue3-apexcharts'
import { allWorkingTime } from '../../api/getWorkingtimes'
import { secondsToHoursData } from '../../utils/addHours'
import { showNotification } from '../notification/showNotifications'

export default {
  methods: {
    async requireData() {
      let response
      try {
        if (this.userId)
          response = await allWorkingTime(this.userId, this.dateData[0], this.dateData[1])
        else response = await allWorkingTime(null, this.dateData[0], this.dateData[1])
        const totalsByDay = {}
        response.data.forEach((entry) => {
          const startDate = new Date(entry.start).toLocaleDateString()

          if (!totalsByDay[startDate]) {
            totalsByDay[startDate] = 0
          }

          totalsByDay[startDate] += entry.working_time_seconds
        })

        const resultArray = Object.entries(totalsByDay).map(([day, time]) => ({
          x: day,
          y: parseFloat(secondsToHoursData(time)).toFixed(2)
        }))

        this.series[0].data = resultArray
        this.chartOptions.xaxis.categories = Object.keys(totalsByDay)
      } catch (error) {
        showNotification('Une erreur est survenue veuillez réessayer plus tard', 'error')
      }
    }
  },
  props: {
    dateData: Array,
    userId: Number
  },
  components: {
    apexchart: VueApexCharts
  },
  data: function () {
    return {
      series: [
        {
          name: 'Total en heures',
          data: [] // Initialise avec un tableau vide
        }
      ],
      chartOptions: {
        chart: {
          height: 350,
          type: 'area',
          toolbar: {
            show: false
          }
        },
        dataLabels: {
          enabled: false
        },
        stroke: {
          curve: 'smooth'
        },
        xaxis: {
          labels: {
            format: 'dd/MM'
          },
          categories: [] // Initialise avec un tableau vide
        },
        tooltip: {
          x: {
            format: 'dd/MM/yy'
          }
        }
      }
    }
  },
  created() {
    this.requireData()
  }
}
</script>
<template>
  <apexchart
    width="100%"
    height="300px"
    type="area"
    :options="chartOptions"
    :series="series"
  ></apexchart>
</template>
