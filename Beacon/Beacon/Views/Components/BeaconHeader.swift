import SwiftUI

struct BeaconHeader: View {
    @ObservedObject var viewModel: BeaconViewModel
    @State var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            let outerCircleWidth = geometry.size.width - 122
            let innerCircleWidth = outerCircleWidth - 60
            
            ZStack(alignment: .center) {
                backgroundCircle.frame(width: outerCircleWidth, height: outerCircleWidth).zIndex(1)
                circle.frame(width: outerCircleWidth, height: outerCircleWidth).zIndex(2)
                innerCircle.frame(width: innerCircleWidth, height: innerCircleWidth).zIndex(2)
                circle.frame(width: outerCircleWidth * 1.5, height: outerCircleWidth * 1.5).scaleEffect(self.animate ? 1 : 0).opacity(0.04)
                circle.frame(width: outerCircleWidth * 1.4, height: outerCircleWidth * 1.4).scaleEffect(self.animate ? 1 : 0).opacity(0.08)
                circle.frame(width: outerCircleWidth * 1.3, height: outerCircleWidth * 1.3).scaleEffect(self.animate ? 1 : 0).opacity(0.1)
                circle.frame(width: outerCircleWidth * 1.2, height: outerCircleWidth * 1.2).scaleEffect(self.animate ? 1 : 0).opacity(0.2)
                circle.frame(width: outerCircleWidth * 1.1, height: outerCircleWidth * 1.1).scaleEffect(self.animate ? 1 : 0).opacity(0.25)
                
                
                VStack {
                    Spacer()
                    Text(modeTitle)
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .zIndex(2)
            }
            .onAppear { self.animate = true }
            .animation(animate ? Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true) : .default, value: animate)
            .onChange(of: viewModel.currentMode) { _ in
                self.animate = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.animate = true
                }
            }
        }
    }
    
    private var circle: some View {
        Circle()
            .trim(from: 0, to: 0.67)
            .stroke(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color(hex: "#F4CC77"),
                            Color(hex: "#C19EF8"),
                            Color(hex: "#58BF9C")
                        ]
                    ),
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 10
            )
            .rotationEffect(.degrees(150))
    }
    
    private var innerCircle: some View {
        Circle()
            .trim(from: 0, to: 0.67)
            .stroke(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color(hex: "#F4CC77"),
                            Color(hex: "#C19EF8"),
                            Color(hex: "#58BF9C")
                        ]
                    ),
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 25
            )
            .opacity(0.3)
            .rotationEffect(.degrees(150))
    }
    
    private var backgroundCircle: some View {
        Circle()
            .trim(from: 0, to: 0.67)
            .fill(Color(hex: "0C0C0B"))
            .rotationEffect(.degrees(150))
    }
    
    private var modeTitle: String {
        switch viewModel.currentMode {
        case .emission: return "Emitting"
        case .scanning: return "Scanning"
        case .none: return "Ready"
        }
    }
}
