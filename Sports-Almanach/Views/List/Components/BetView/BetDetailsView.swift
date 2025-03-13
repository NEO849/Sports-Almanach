// MARK: - Imports
import SwiftUI

/// Detailansicht für einen einzelnen Wettschein
struct BetDetailsView: View {
    // MARK: - Properties
    let bet: Bet
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrund
                Color.black.opacity(0.9)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        Text("Wettschein #\(bet.betSlipNumber)")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        // Event Details
                        EventDetailsSection(bet: bet)
                        
                        // Wett-Details
                        BetDetailsSection(bet: bet)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Schließen") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
}

// MARK: - Helper Views
/// Sektion für Event-Details
private struct EventDetailsSection: View {
    let bet: Bet
    
    var body: some View {
        VStack(spacing: 8) {
            Text(bet.event.name)
                .font(.headline)
            Text("\(bet.event.date) um \(bet.event.time)")
                .font(.subheadline)
        }
        .foregroundColor(.white)
    }
}

/// Sektion für Wett-Details
private struct BetDetailsSection: View {
    let bet: Bet
    
    // Formatiere Zahlen als String mit 2 Dezimalstellen
       private func formatAmount(_ amount: Double) -> String {
           String(format: "%.2f", amount)
       }
    
    var body: some View {
        VStack(spacing: 12) {
            DetailRow(title: "Wetteinsatz:", value: "\(formatAmount(bet.betAmount)) €")
            DetailRow(title: "Quote:", value: formatAmount(bet.odds))
            DetailRow(title: "Tipp:", value: bet.userPick.titleGerman)
            if let winAmount = bet.winAmount {
                DetailRow(title: "Möglicher Gewinn:", value: "\(formatAmount(winAmount)) €")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
/// Einzelne Detail-Zeile
private struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview
#Preview {
    let mockBet = Bet(
        id: UUID(),
        event: MockEvents.events[0],
        userPick: .homeWin,
        odds: 2.5,
        betAmount: 10,
        winAmount: 25.0,
        timestamp: Date(),
        betSlipNumber: 1
    )
    
    BetDetailsView(bet: mockBet)
}
