import Foundation

enum BeaconStatus: String {
    case bluetoothPoweredOn = "🟢 Bluetooth is powered on and ready."
    case bluetoothPoweredOff = "🔴 Bluetooth is powered off."
    case bluetoothNotPoweredOn = "📴 Bluetooth is not powered on."
    case bluetoothNotAvailable = "❌ Bluetooth is not available."
    
    case startingUpEmittion = "🔃 Starting up emiition of beacon"
    case startedEmitting = "📡 Started emitting beacon."
    case stoppedEmitting = "✋🏼 Stopped emitting beacon."
    
    case startingUpScanning = "🔃 Starting up scanning of beacon"
    case startedScanning = "📡 Started scanning beacon."
    case stoppedScanning = "✋🏼 Stopped scanning beacon."
    
    case invalidUUID = "😬 The used UUID was not valid"
    
    case deviceConfigDone = "📱 Your periphical configuration is loaded"
    case deviceConfigFailed = "🔴 Failed to create a periphical configuration"
    
    case authDenied = "⛔️ Authorization for location denied"
    case authGranted = "✅ Authorization for location granted"
    
    case notificationsDenied = "⛔️ Authorization for notifications denied"
    case notificationsGranted = "✅ Authorization for notifications granted"
    
    case exitedRegion = "🚪 You just exited a region"
    
    case unknownError = "❌ An unknown error occurred."
    case locationManagerError = "🚨 Location Manager Error"
}

