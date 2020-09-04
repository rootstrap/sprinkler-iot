const mqtt = require('mqtt')
let client
const DEVICE_ID = process.env.DEVICE_ID || '1'
const HOST = process.env.SERVICE_HOST || 'localhost'
const PORT = process.env.SERVICE_PORT || '1883'
const USERNAME = process.env.USER_NAME || ''
const PASSWORD = process.env.PASSWORD || ''

/**
 * Simulating the device's setup function/
 */
function setup() {
  client = mqtt.connect({ host: HOST, port: parseInt(PORT), username: USERNAME, password: PASSWORD })
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
    tmp: readTemperature(),
    hum: readHumidity(),
    moist: readSoilMoisture()
  }
}

function readTemperature() {
  return randomNumber(10, 20)
}

function readHumidity() {
  return randomNumber(30, 60)
}

function readSoilMoisture() {
  return randomNumber(40, 80)
}

function randomNumber(min, max) {
  return Math.floor(Math.random() * (max - min) + min);
}


setup()
loop()
