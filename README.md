# Ignition 1.0 – Driver Telemetry System
## Built by Team McQueen

Finished 11th out of 59 teams at the Ignition 1.0 Hackathon, conducted by Team VEGAVATH, PES University EC Campus and Powered by [ATHER ENERGY](https://www.atherenergy.com/)

📅 7th & 8th November 2025

## Project Overview
This project is a mobile-based driver telemetry and rider-state detection system that collects real-time sensor data from a smartphone and classifies rider movement into walking, running, scooter, or bike riding.
The phone is mounted securely on the rider’s chest using a normal belt, enabling accurate motion and orientation capture without additional sensors or hardware modules.

The system visualizes live telemetry, GPS routes, speed, and motion data within a mobile app and stores all readings locally with timestamps.

## Hackathon Problem Statement
- Participants must build a wearable telemetry system that attaches to a rider’s helmet, jacket, and/or pants and captures real-time motion and location data.
- The system must display live information on a mobile app and store all readings with timestamps.
- The app should also detect whether the rider is on a scooter, a motorcycle, or not riding, based on posture and motion.
- All prototypes must be fully demonstrable on the test track during the hackathon.

## Rider State Classification Logic

The mounted position captures torso orientation changes and vibration/tilt patterns:

- High-frequency oscillation → running
- Low vibration + minimal lean angle → scooter riding
- Sharp gyroscopic variation during leaning → bike riding
- Vertical body motion periodicity → walking

## Features

- Live GPS route mapping & speed calculation
- Real-time IMU visual telemetry
- Activity classification: Walking / Running / Scooter / Bike
- Timestamped local logging
- Low-cost wearable prototype + battery efficient
- Minimal weight mount with no stains or damage to gear

## Tech Stack

| Component     | Technology                                                  |
| ------------- | ----------------------------------------------------------- |
| Website       | Flask                                                       |
| App           | Flutter                                                     |
| Sensors       | IMU (Accelerometer + Gyroscope) & GPS                       |
| Data Storage  | Local database                                              |
| Visualization | Charts, Maps, Graphs                                        |
| Hardware      | Smartphone + normal belt                                    |

## Team Members 
[![Contributors](https://contrib.rocks/image?repo=dotpmm/ignition-driver-telemetry-system&nocache=1)](https://github.com/dotpmm/ignition-driver-telemetry-system/graphs/contributors)

## If you found this project interesting, consider giving the repo a star ⭐!
