const mqtt = require('mqtt')
let client
const DEVICE_ID = process.env.DEVICE_ID || '1'

/**
 * Simulating the device's setup function/
 */
function setup() {
  client = mqtt.connect('mqtt://localhost')
}

/**
 * Arduinos are programed with a loop function, that runs constantly
 * and so it's better to read everything in one go and just set a sort
 * of busy waiting or debounce in order to avoid sending messages too often.
 */
function loop() {
  setInterval(() => {
    client.publish(`rs/${DEVICE_ID}/telemetry`, JSON.stringify(readTelemetry()))
  }, 3000)
}

/**
 * Telemetry or readings are classical names from the IoT domain
 */
function readTelemetry() {
  return {
    tmp: readTemperature()
  }
}

function readTemperature() {
  return randomNumber(10, 20)
}

function randomNumber(min, max) {
  return Math.floor(Math.random() * (max - min) + min);
}


setup()
loop()
