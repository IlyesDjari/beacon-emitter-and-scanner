import SwiftUI
import CoreBluetooth
import CoreLocation

/// Manages the emission of beacon signals.
class BeaconEmitter: NSObject, CBPeripheralManagerDelegate, ObservableObject {
    
    /// The view model associated with the emitter.
    var viewModel: BeaconViewModel
    
    /// The peripheral manager responsible for emitting beacon signals.
    var peripheralManager: CBPeripheralManager?

    /// Initializes a new instance of BeaconEmitter.
    /// - Parameter viewModel: The view model associated with the emitter.
    init(viewModel: BeaconViewModel) {
        self.viewModel = viewModel
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    /// Starts emitting beacon signals.
    func startEmitting() {
        viewModel.updateEmittingStatus(with: .startingUpEmittion)
        
        guard let peripheralManager = peripheralManager, peripheralManager.state == .poweredOn else {
            viewModel.updateEmittingStatus(with: .bluetoothNotPoweredOn)
            return
        }
        guard let proximityUUID = UUID(uuidString: "39ED98FF-2900-441A-802F-9C398FC199D2") else {
            viewModel.updateEmittingStatus(with: .invalidUUID)
            return
        }
        let major : CLBeaconMajorValue = 100
        let minor : CLBeaconMinorValue = 1
        let beaconID = "com.icapps.beacon"
        let region = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: beaconID)
        
        guard let peripheralData = region.peripheralData(withMeasuredPower: nil) as? [String: Any] else {
            viewModel.updateEmittingStatus(with: .deviceConfigFailed)
            return
        }
        viewModel.updateEmittingStatus(with: .deviceConfigDone)
        peripheralManager.startAdvertising(peripheralData)
        viewModel.updateEmittingStatus(with: .startedEmitting)
        viewModel.currentMode = .emission
    }
    
    /// Stops emitting beacon signals.
    func stopEmitting() {
        peripheralManager?.stopAdvertising()
        viewModel.updateEmittingStatus(with: .stoppedEmitting)
        viewModel.currentMode = .none
        viewModel.emittingStatus.removeAll()
    }
    
    /// Handles state updates of the peripheral manager.
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            viewModel.updateEmittingStatus(with: .bluetoothPoweredOn)
        case .poweredOff:
            viewModel.updateEmittingStatus(with: .bluetoothPoweredOff)
        case .unauthorized, .unsupported, .unknown, .resetting:
            viewModel.updateEmittingStatus(with: .bluetoothNotAvailable)
        @unknown default:
            viewModel.updateEmittingStatus(with: .unknownError)
        }
    }
}
