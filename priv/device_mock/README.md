## Device mock

The device will connect to an MQTT Broker and start publishing random telemetry every
three seconds. To run the script you will first need to install the dependencies with
`npm install` and then just

```bash
$ DEVICE_ID=some-id node client.js
```
