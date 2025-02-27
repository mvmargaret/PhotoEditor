//
//  PasswordResetView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 01/08/24.
//

import SwiftUI

struct PasswordResetView: View {
	@EnvironmentObject var authManager: AuthManager
	@Environment(\.dismiss) var dismiss
	@State private var isResetPasswordEmailSent = false
	@State private var isErrorPresented = false
	@State private var currentError: Error? = nil
	
    var body: some View {
	
			if isResetPasswordEmailSent {
				instructionsAfterResetPasswordEmailSent
					.transition(.opacity)
			} else {
				resetPassword
					.transition(.opacity)
					.errorAlert(
						isPresented: $isErrorPresented,
						message: currentError?.localizedDescription ?? "Try again later"
					)					
			}
		
    }
	private var resetPassword: some View {
		Form {
			Section("Восстановление пароля") {
				TextField("Введите эл. почту", text: $authManager.email)
			}
			
			Section {
				MainButton(
					title: "Продолжить",
					action: {
						authManager.resetPassword { result in
							switch result {
							case .success():
								withAnimation {
									isResetPasswordEmailSent = true
								}
							case .failure(let error):
								isErrorPresented = true
								currentError = error
							}
						}
					},
					color: .indigo.opacity(08)
				)
			}
			.listRowInsets(.init())
			.listRowBackground(Color.clear)
		}
	}
	
	private var instructionsAfterResetPasswordEmailSent: some View {
		VStack {
			Text("A letter with instructuions has been sent to your email. Please check your email and follow instructions")
			Button("Exit") {
				dismiss()
			}
		}
	}
}

#Preview {
    PasswordResetView()
}
