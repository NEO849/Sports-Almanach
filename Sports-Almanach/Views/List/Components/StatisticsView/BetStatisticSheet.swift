//
//  BetSlipDetailSheet.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 30.03.25.
//

import SwiftUI

/// Sheet-Ansicht , zeigt alle enthaltenen Wetten mit Details und Bildern an
struct BetSlipDetailSheet: View {

    let betSlip: BetSlip
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Hintergrund
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: - Hauptinhalt
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Header
                        headerSection
                        
                        // MARK: - Wettliste
                        betsSection
                        
                        // MARK: - Footer
                        footerSection
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
                }
            }
        }
    }
    
    // MARK: - Header Section
    /// Kopfbereich mit Wettschein-Nummer und Datum
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Wettschein #\(betSlip.slipNumber)")
                .font(.title)
                .foregroundColor(.white)
            
            Text("Erstellt am: \(betSlip.createdAt.formatted())")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            statusBadge
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
    }
    
    // MARK: - Status Badge
    /// Zeigt den Gewinn/Verlust-Status des Wettscheins an
    private var statusBadge: some View {
        HStack {
            Image(systemName: betSlip.isWon ? "checkmark.circle.fill" : "xmark.circle.fill")
            Text(betSlip.isWon ? "Gewonnen" : "Verloren")
            if let winAmount = betSlip.winAmount {
                Text("(\(winAmount, specifier: "%.2f") €)")
            }
        }
        .foregroundColor(betSlip.isWon ? .green : .orange)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(betSlip.isWon ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
        .cornerRadius(15)
    }
    
    // MARK: - Bets Section
    /// Liste aller Einzelwetten des Wettscheins
    private var betsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Wetten")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ForEach(betSlip.bets, id: \.id) { bet in
                BetDetailRow(bet: bet)
            }
        }
    }
    
    // MARK: - Footer Section
    /// Zusammenfassung mit Gesamteinsatz und Gewinn
    private var footerSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Gesamteinsatz:")
                    .foregroundColor(.white)
                Spacer()
                Text("\(betSlip.betAmount, specifier: "%.2f") €")
                    .foregroundColor(.white)
            }
            
            if let winAmount = betSlip.winAmount {
                HStack {
                    Text("Gewinn:")
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(winAmount, specifier: "%.2f") €")
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
    }
}

// MARK: - BetDetailRow
/// Zeigt die Details einer einzelnen Wette an
private struct BetDetailRow: View {
    let bet: Bet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Event-Header
            HStack {
                // Event-Bild
                AsyncImage(url: URL(string: bet.event.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                
                // Event-Details
                VStack(alignment: .leading) {
                    Text(bet.event.name)
                        .foregroundColor(.white)
                    Text("\(bet.event.homeTeam) vs \(bet.event.awayTeam)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Wettdetails
            HStack {
                VStack(alignment: .leading) {
                    Text("Dein Tipp:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(bet.userTip.titleGerman)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Quote:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(bet.odds, specifier: "%.2f")")
                        .foregroundColor(.white)
                }
            }
            
            // Ergebnis falls vorhanden
            if let winAmount = bet.winAmount {
                HStack {
                    Text("Ergebnis:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(winAmount, specifier: "%.2f") €")
                        .foregroundColor(bet.isWon ? .green : .orange)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
    }
}

// MARK: - Preview
struct BetSlipDetailSheet_Previews: PreviewProvider {
    static var previews: some View {
        // Beispiel-Wettschein für Preview
        let mockBetSlip = BetSlip(
            id: UUID(),
            userId: "123",
            slipNumber: 1,
            bets: [],
            createdAt: Date(),
            isWon: true,
            betAmount: 10.0,
            winAmount: 25.0
        )
        
        BetSlipDetailSheet(betSlip: mockBetSlip)
    }
}
