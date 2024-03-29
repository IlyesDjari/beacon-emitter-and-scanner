import CoreLocation
import Combine
import UserNotifications

/// Manages the scanning for nearby beacons.
class BeaconScanner: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    /// Published property holding the array of discovered beacons.
    @Published var beacons: [CLBeacon] = []
    
    /// The view model associated with the scanner.
    var viewModel: BeaconViewModel
    
    /// The location manager responsible for beacon scanning.
    var locationManager: CLLocationManager?
    
    /// Initializes a new instance of BeaconScanner.
    /// - Parameter viewModel: The view model associated with the scanner.
    init(viewModel: BeaconViewModel) {
        self.viewModel = viewModel
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        requestNotificationPermission()
    }
    
    /// Starts scanning for beacons.
    func startScanning() {
        guard let locationManager = locationManager else { return }
        viewModel.updateEmittingStatus(with: .startingUpScanning)
        
        let proximityUUID = UUID(uuidString: "39ED98FF-2900-441A-802F-9C398FC199D2")
        let constraint = CLBeaconIdentityConstraint(uuid: proximityUUID!)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "com.icapps.beacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: constraint)
        viewModel.currentMode = .scanning
        viewModel.updateEmittingStatus(with: .startedScanning)
    }
    
    /// Stops scanning for beacons.
    func stopScanning() {
        guard let locationManager = locationManager else { return }
        
        for region in locationManager.monitoredRegions {
            guard let beaconRegion = region as? CLBeaconRegion else { continue }
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        }
        locationManager.stopUpdatingLocation()
        
        viewModel.currentMode = .none
        viewModel.updateEmittingStatus(with: .stoppedScanning)
        viewModel.emittingStatus.removeAll()
    }
    
    /// Requests permission for notifications.
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [self] granted, error in
            if granted {
                viewModel.updateEmittingStatus(with: .notificationsGranted)
            } else if error != nil {
                viewModel.updateEmittingStatus(with: .notificationsDenied)
            }
        }
    }
    
    /// Handles changes in location manager authorization status.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            viewModel.updateEmittingStatus(with: .authGranted)
        } else {
            viewModel.updateEmittingStatus(with: .authDenied)
        }
    }
    
    /// Notifies when beacons are ranged in a region.s
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("Entered region: \(beaconRegion.identifier)")
            // Start ranging beacons in the region to get their major and minor values.
            manager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        }
    }
    
    /// Notifies when the device enters a beacon region.
    func locationManager(_ manager: CLLocationManager, didRangeBeacons foundBeacons: [CLBeacon], in region: CLBeaconRegion) {
        DispatchQueue.main.async {
            // Update your beacons array with the found beacons.
            self.beacons = foundBeacons
            
            // Check if there are any beacons found. If so, send a summary notification.
            if !foundBeacons.isEmpty {
                let beaconCount = foundBeacons.count
                let firstBeacon = foundBeacons[0] // Example using the first beacon for details.
                
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "🕵️‍♀️ Beacons Detected!"
                notificationContent.body = "Detected \(beaconCount) beacons near you. Beacon with UUID: \(firstBeacon.proximityUUID), major: \(firstBeacon.major), minor: \(firstBeacon.minor)."
                notificationContent.sound = .default
                
                // Use a unique identifier for the notification to replace any existing notification of this type.
                let request = UNNotificationRequest(identifier: "beaconDetectionSummary", // A constant identifier ensures replacing the previous notification.
                                                    content: notificationContent,
                                                    trigger: nil)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error  {
                        print("Notification Error: \(error)")
                    }
                }
            }
        }
    }

    
    /// Notifies when the device exits a beacon region.
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            viewModel.updateEmittingStatus(with: .exitedRegion)
            locationManager?.stopRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        }
    }
    
    /// Notifies when an error occurs in location manager operations.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        viewModel.updateEmittingStatus(with: .locationManagerError)
    }
}
