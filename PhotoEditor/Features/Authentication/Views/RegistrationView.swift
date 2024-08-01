//
//  RegistrationView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//

import SwiftUI

struct RegistrationView: View {
	@EnvironmentObject var authManager: AuthManager
	@State private var currentError: Error? = nil
	@State private var isErrorPresented = false
	
    var body: some View {
		VStack {
			Form {
				Section("Create account") {
					TextField("Email", text: $authManager.email)
					SecureField("Password", text: $authManager.password)
				}
				
				Section {
					Button("Create account") {
						authManager.createAccount { result in
							switch result {
							case .success():
								print("account created")
							case .failure(let error):
								print("Error when created account: \(error.localizedDescription)")
								isErrorPresented = true
								currentError = error
							}
						}
					}
				}
			}
		}
		.errorAlert(isPresented: $isErrorPresented, message: currentError?.localizedDescription ?? "Try again later")
    }
}

#Preview {
    RegistrationView()
}
