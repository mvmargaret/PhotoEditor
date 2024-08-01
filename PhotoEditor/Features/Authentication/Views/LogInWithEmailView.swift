//
//  LogInWithEmailView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//

import SwiftUI

struct LogInWithEmailView: View {
	@EnvironmentObject var authManager: AuthManager
	@State private var currentError: Error? = nil
	@State private var isErrorPresented = false
	
    var body: some View {
		VStack {
			Form {
				Section("Enter your email and password") {
					TextField("Email", text: $authManager.email)
					SecureField("Password", text: $authManager.password)
				}
				
					Button("Sign in") {
						authManager.login { result in
							switch result {
							case .success():
								print("success")
							case .failure(let error):
								print("Error with sign in: \(error.localizedDescription)")
								currentError = error
								isErrorPresented = true
							}
						}
					}
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(.cyan)
					.listRowInsets(.init())
					.listRowBackground(Color.clear)
			}
			
		}
		.errorAlert(isPresented: $isErrorPresented, message: currentError?.localizedDescription ?? "Try again later")
    }
}

#Preview {
    LogInWithEmailView()
}
