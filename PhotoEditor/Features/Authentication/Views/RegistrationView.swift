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
				Section("Зарегистрироваться") {
					TextField("Email", text: $authManager.email)
					SecureField("Password", text: $authManager.password)
				}
				
				Section {
					
					MainButton(
						title: "Зарегистрироваться",
						action: {
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
						},
						color: .indigo.opacity(08)
					)
					.listRowInsets(.init())
					.listRowBackground(Color.clear)
				}
			}
		}
		.errorAlert(isPresented: $isErrorPresented, message: currentError?.localizedDescription ?? "Try again later")
    }
}

#Preview {
    RegistrationView()
}
