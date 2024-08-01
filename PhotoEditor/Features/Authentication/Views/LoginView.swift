//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 30/07/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
	@EnvironmentObject var authManager: AuthManager
	@State private var isShowLoginWithEmailView = false
//	@State private var isShowSignInWithGoogleView = false
	@State private var isShowRegistrationView = false
	@State private var isShowPasswordResetView = false
	
    var body: some View {
		VStack {
			buttonSignInGoogle
			buttonLoginEmail
			buttonResetPassword
			Text("или")
			buttonCreateAccount
		}
		.padding()
		.sheet(isPresented: $isShowLoginWithEmailView) {
			LogInWithEmailView()
		}
		.sheet(isPresented: $isShowRegistrationView) {
			RegistrationView()
		}
		.sheet(isPresented: $isShowPasswordResetView) {
			PasswordResetView()
		}
    }
	
	private var buttonLoginEmail: some View {
		MainButton(
			title: "Войти через эл. почту",
			action: {
				isShowLoginWithEmailView = true
			},
			color: .cyan
		)
	}
	
	private var buttonCreateAccount: some View {
		MainButton(
			title: "Создать аккаунт",
			action: {isShowRegistrationView = true},
			color: .blue
		)
	}
	
	private var buttonResetPassword: some View {
		Button("Не помните пароль?") {
			isShowPasswordResetView = true
		}
	}
	
	private var buttonSignInGoogle: some View {
		MainButton(
			title: "Продолжить с Google",
			action: {authManager.signInWithGoogle(presentingViewController: self.getRootViewController())},
			color: .mint
		)
	}
	
}

#Preview {
    LoginView()
}
