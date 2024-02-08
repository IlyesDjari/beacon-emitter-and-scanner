import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = BeaconViewModel()
    @StateObject private var beaconEmitter: BeaconEmitter
    @StateObject private var beaconScanner: BeaconScanner
    
    init() {
        let sharedViewModel = BeaconViewModel()
        _viewModel = StateObject(wrappedValue: sharedViewModel)
        _beaconEmitter = StateObject(wrappedValue: BeaconEmitter(viewModel: sharedViewModel))
        _beaconScanner = StateObject(wrappedValue: BeaconScanner(viewModel: sharedViewModel))
    }
    
    var body: some View {
        ZStack {
            Color(hex: "##0C0C0B")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                BeaconHeader(viewModel: viewModel)
                
                ScrollView {
                    VStack(spacing: 20) {
                        statusView
                    }
                    .padding()
                }
                .background(Color.clear)
                
                Spacer()
                
                HStack(spacing: 20) {
                    beaconButton
                    scanButton
                }
                .padding(22)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private var beaconButton: some View {
        Button(action: toggleBeaconMode) {
            Text(viewModel.currentMode == .emission ? "Stop" : "Emitt")
                .fontWeight(.semibold)
        }
        .buttonStyle(PrimaryButtonStyle(isActive: viewModel.currentMode == .emission))
    }
    
    private var scanButton: some View {
        Button(action: toggleScanMode) {
            Text(viewModel.currentMode == .scanning ? "Stop" : "Scan")
                .fontWeight(.semibold)
        }
        .buttonStyle(SecondaryButtonStyle(isActive: viewModel.currentMode == .scanning))
    }
    
    private var statusView: some View {
        switch viewModel.currentMode {
        case .emission:
            return AnyView(EmissionStatusView(emittingStatus: viewModel.emittingStatus))
        case .scanning:
            return AnyView(ScanningStatusView(beacons: beaconScanner.beacons))
        case .none:
            return AnyView(EmptyView())
        }
    }
    
    private func toggleBeaconMode() {
        if viewModel.currentMode == .emission {
            beaconEmitter.stopEmitting()
        } else {
            beaconEmitter.startEmitting()
        }
    }
    
    private func toggleScanMode() {
        if viewModel.currentMode == .scanning {
            beaconScanner.stopScanning()
        } else if beaconEmitter.peripheralManager?.state == .poweredOn {
            beaconScanner.startScanning()
        } else {
            print("Bluetooth is not ready or permissions not granted.")
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var isActive: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(Color(hex: "#0C0C0B"))
            .background(isActive ? Color(hex: "#F8D26B") : Color(hex: "#58BF9C"))
            .cornerRadius(10)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var isActive: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(Color(hex: "#0C0C0B"))
            .background(isActive ? Color(hex: "#F8D26B") : Color(hex: "#C19EF8"))
            .cornerRadius(10)
    }
}
