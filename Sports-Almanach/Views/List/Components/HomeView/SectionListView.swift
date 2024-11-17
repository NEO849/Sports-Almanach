//
//  SectionListView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 17.11.24.
//

import SwiftUI

struct SectionListView: View {
    @Binding var expandedSection: String?
    
    var body: some View {
        VStack(spacing: 10) {
            SectionView(sectionName: "Events", expandedSection: $expandedSection)
                .frame(minHeight: 80)
            SectionView(sectionName: "Event-Details", expandedSection: $expandedSection)
                .frame(minHeight: 80)
            SectionView(sectionName: "Wetten", expandedSection: $expandedSection)
                .frame(minHeight: 80)
            SectionView(sectionName: "Statistiken", expandedSection: $expandedSection)
                .frame(minHeight: 80)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 20)
    }
}

struct SectionView: View {
    let sectionName: String
    @Binding var expandedSection: String?
    
    private var isExpanded: Bool {
        expandedSection == sectionName
    }
    
    // Opazität für nicht ausgewählte Sektionen
    private var sectionOpacity: Double {
        expandedSection == nil || expandedSection == sectionName ? 1.0 : 0.3
    }
    
    var body: some View {
        VStack {
            DisclosureGroup(isExpanded: Binding(
                get: { isExpanded },
                set: { expandedSection = $0 ? sectionName : nil }
            )) {
                switch sectionName {
                case "Events":
                    Text("Hier findest du eine riesige Auswahl an Events von verschiedenen Sportarten.")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                case "Event-Details":
                    Text("Infos jeglicher Art, das Spiel als Video verfolgen und deine Lieblingsszenen anschauen.")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                case "Wetten":
                    Text("Zeig dein Können als Sport-Analyst, teste dein Wissen und wette auf spannende Spiele.")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                case "Statistiken":
                    Text("Behalte den Überblick Ranglisten uvm.")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                default:
                    Text("Default")
                }
            } label: {
                HStack {
                    Text(sectionName)
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding()
                    Spacer()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isExpanded ? Color.black.opacity(0.4) : Color.black.opacity(0.1))
                    .shadow(
                        color: isExpanded ? .black : .orange,
                        radius: isExpanded ? 10 : 1
                    )
            )
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .opacity(sectionOpacity)  // Dynamische Opazität für nicht ausgewählte Sektionen
            .animation(.easeInOut, value: expandedSection)
        }
    }
}
