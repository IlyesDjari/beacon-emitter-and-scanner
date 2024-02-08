import CoreLocation

struct Beacon {
    let uuid: UUID
    let major: CLBeaconMajorValue
    let minor: CLBeaconMinorValue
    let identifier: String
}

