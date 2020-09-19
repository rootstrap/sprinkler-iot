## Device mock

The device will connect to an MQTT Broker and start publishing random telemetry every
three seconds. To run the script you will first need to install the dependencies with
`npm install` and then just

```bash
$ DEVICE_ID=some-id node client.js
```

You can also provide the following options as ENV vars:
```
SERVICE_HOST (default: 'localhost')
SERVICE_PORT (default: '1883')
USER_NAME (default: '')
PASSWORD (default: '')
```

If you don't want to add this config every time you run the script you can just:

```bash
$ export SERVICE_HOST=some-remote.host.com
$ export SERVICE_PORT=18503
# ...
```
