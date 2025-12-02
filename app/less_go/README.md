# Team McQueen Sensor Streamer App (less_go)

A lightweight Flutter application that captures device sensor data and streams it to a backend endpoint in real time.

## Features

* Collects accelerometer, gyroscope, compass heading, and GPS position.
* Buffers readings and posts them to a server every 200ms.
* Configurable server endpoint (persisted locally).
* Permission-aware (location + sensor access).
* Live on-screen preview of sensor values.

## Stack

* Flutter (Material)
* sensors_plus
* flutter_compass
* geolocator
* permission_handler
* http
* shared_preferences

## Usage

1. Install the app on an Android device.
2. Enter your backend API endpoint in the text field.
3. Grant required permissions.
4. The app will begin streaming sensor data automatically.
