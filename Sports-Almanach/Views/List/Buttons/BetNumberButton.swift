// MARK: - Imports
import SwiftUI

/// Button für die Anzeige der Wettnummer in der seitlichen Liste
struct BetNumberButton: View {
    // MARK: - Properties
    let bet: Bet
    @EnvironmentObject var userViewModel: UserViewModel
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("#\(bet.betSlipNumber)")
                    .font(.system(.body, design: .monospaced))
                    .bold()
            }
            .padding(12)
            .frame(width: 80)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.3))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 1)
            )
            .foregroundColor(.white)
        }
    }
}

// MARK: - Preview
#Preview {
    let mockBet = Bet(
        id: UUID(),
        event: MockEvents.events[0],
        userTip: .homeWin,
        odds: 2.5,
        betAmount: 10, winAmount: 30.0,
        timestamp: Date(),
        betSlipNumber: 1
    )
    
    BetNumberButton(bet: mockBet) {
        print("Button tapped")
    }
}
