//
//  LogoutButton.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 17.11.24.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var showLoginView: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                userViewModel.logout()
                showLoginView = true
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.blue)
                    .padding(.top, 28)
                    .padding(.trailing, 38)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
