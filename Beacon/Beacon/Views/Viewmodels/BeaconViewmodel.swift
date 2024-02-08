import SwiftUI

/// View model for managing beacon-related states and statuses.
class BeaconViewModel: ObservableObject {
    @Published var currentMode: BeaconMode = .none
    @Published var emittingStatus: [String] = []
    @Published var colorIndex = 1
    
    /// Updates the emitting status with the provided status and appends it to `emittingStatus`.
    ///
    /// - Parameter status: The status of the beacon.
    func updateEmittingStatus(with status: BeaconStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.emittingStatus.append(status.rawValue)
            print(status.rawValue)
        }
    }
}
