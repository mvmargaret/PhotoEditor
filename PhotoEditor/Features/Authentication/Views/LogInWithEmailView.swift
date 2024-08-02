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
				Section("Продолжить с эл. почтой") {
					TextField("Email", text: $authManager.email)
					SecureField("Password", text: $authManager.password)
				}
				
				MainButton(
					title: "Войти",
					action: { authManager.login { result in
						switch result {
						case .success():
							print("success")
						case .failure(let error):
							print("Error with sign in: \(error.localizedDescription)")
							currentError = error
							isErrorPresented = true
						}
						}
					},
					color: .indigo.opacity(08)
				)
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
