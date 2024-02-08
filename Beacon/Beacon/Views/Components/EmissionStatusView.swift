import SwiftUI

struct EmissionStatusView: View {
    var emittingStatus: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("You're emitting, these are the logs")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(emittingStatus.indices, id: \.self) { status in
                VStack(alignment: .leading) {
                    Text(emittingStatus[status])
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#3C4042"))
                .cornerRadius(10)
            }
        }
    }
}
