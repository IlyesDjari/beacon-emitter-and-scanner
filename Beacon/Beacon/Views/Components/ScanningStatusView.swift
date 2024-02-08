import SwiftUI
import CoreLocation

struct ScanningStatusView: View {
    var beacons: [CLBeacon]
    
    var body: some View {
        VStack {
            if beacons.isEmpty {
                Text("Scanning: No beacons have been found")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(alignment: .leading) {
                    Text("Scanning: Found \(beacons.count) Beacons")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    ScrollView {
                        ForEach(beacons, id: \.self) { beacon in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(beacon.uuid.uuidString)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                HStack {
                                    Text("Accuracy: \(beacon.accuracy)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("Signal: \(beacon.rssi)dB")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("Major: \(beacon.major)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("Minor: \(beacon.minor)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("Proximity: \(beacon.proximity.rawValue)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(16)
                            .background(Color(hex: "#3C4042"))
                            .cornerRadius(10)
                            .padding(.bottom, 8)
                        }
                    }
                }
            }
        }
    }
}
