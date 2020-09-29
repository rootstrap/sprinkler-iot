import TelemetryChartHook from './telemetry_chart_hook'

const hooks = [
  TelemetryChartHook,
]

function registerHook({ name: name , ...hook }, registeredHooks) {
  return { ...registeredHooks, [name]: hook }
}

export default hooks.reduce((registeredHooks, hook) => registerHook(hook, registeredHooks), {})
