Push-Location -Path mosquitto
& ./start-mosquitto.ps1
Pop-Location

Push-Location -Path rabbitmq
& ./start-rabbitmq.ps1
Pop-Location

Push-Location -Path maildev
& ./start-maildev.ps1
Pop-Location