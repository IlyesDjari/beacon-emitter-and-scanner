# Beacon Emitter and Scanner

This project demonstrates the functionality of emitting and detecting beacons using an iPhone. It consists of two main components: a beacon emitter and a beacon scanner. The emitter broadcasts a signal, while the scanner detects nearby beacons even when the app is running in the background.

## Components

### Beacon Emitter

The `BeaconEmitter` class is responsible for emitting a beacon signal. It utilizes the CoreBluetooth framework to manage Bluetooth communication and the CoreLocation framework to create and broadcast the beacon signal. The emitter can start and stop emitting the signal based on the current state of the device's Bluetooth and location services.

### Beacon Scanner

The `BeaconScanner` class scans for nearby beacons using the iPhone's location capabilities. It utilizes the CoreLocation framework to monitor and range nearby beacon regions. The scanner operates in the background, allowing it to detect beacons even when the app is not actively running.

### Beacon ViewModel

The `BeaconViewModel` class serves as the central data manager for the beacon-related states and statuses. It manages the current mode of the beacon (emitting or scanning), keeps track of emitting statuses, and handles color indexes for the UI.

## Usage

1. **Beacon Emitter**: Open the app and Press the "Emit" button to start emitting the beacon signal. The app will broadcast the signal until you press the "Stop" button.

2. **Beacon Scanner**: Open the app and Press the "Scan" button to start scanning for nearby beacons. The app will detect and display any nearby beacons, even when running in the background or terminating the app. Press the "Stop" button to stop scanning.

## Requirements

- iOS device with Bluetooth and location capabilities
- Xcode IDE
- Swift programming knowledge
- Basic understanding of Bluetooth and CoreLocation frameworks

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For any questions or inquiries, please contact Ilyes Djari at ilyes.djari@icapps.com.
