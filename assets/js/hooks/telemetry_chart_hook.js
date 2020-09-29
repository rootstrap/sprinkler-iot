import Chart from 'chart.js'

function TelemetryChartHook() {
  function initChart() {
    const datasetOptions = {
      fill: false,
      borderWidth: 2,
      lineTension: 0.4,
    }

    const ctx = document.getElementById('telemetry-chart')
    return new Chart(ctx, {
      type: 'line',
      data: {
        datasets: [{
          label: 'Sprinkler 1',
          data: [],
          borderColor: '#2bbb85',
          ...datasetOptions
        }, {
          label: 'Sprinkler 2',
          data: [],
          borderColor: '#b5b5b8',
          ...datasetOptions
        }]
      },
      options: {
        tooltips: { enabled: false },
        scales: {
          xAxes: [{
            type: 'linear',
            position: 'bottom',
            display: true,
            ticks: {
              callback: function(value, _index, _values) {
                return (new Date(value)).toLocaleTimeString(navigator.language, {
                  hour: '2-digit',
                  minute:'2-digit',
                  weekday: 'short'
                })
              }
            }
          }],
          yAxes: [{
            ticks: {
              suggestedMin: 0,
              suggestedMax: 30
            }
          }]
        }
      }
    })
  }

return {
    name: 'TelemetryChartHook',
    mounted() {
      this.chart = initChart()
      this.prevLength = [0, 0]
    },

    updated() {
      const readings = JSON.parse(this.el.dataset.readings)

      readings.forEach(({ tmps }, i) => {
        if (tmps.length > this.prevLength[i]) {
          const [tmp, date] = tmps[0]
          const newData = { x: (new Date(date)).getTime(), y: tmp, name: tmp }
          this.chart.data.datasets[i].data.push(newData)
          this.prevLength[i] = tmps.length
          this.chart.update()
        }
      })
    }
  }
}

export default TelemetryChartHook()
