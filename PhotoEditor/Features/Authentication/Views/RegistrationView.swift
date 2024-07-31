//
//  RegistrationView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//

import SwiftUI

struct RegistrationView: View {
	@EnvironmentObject var authManager: AuthManager
	
    var body: some View {
		VStack {
			Form {
				Section("Create account") {
					TextField("Email", text: $authManager.email)
					SecureField("Password", text: $authManager.password)
				}
				
				Section {
					Button("Create account") {
						authManager.createAccount()
					}
				}
			}
		}
    }
}

#Preview {
    RegistrationView()
}
