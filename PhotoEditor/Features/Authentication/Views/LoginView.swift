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
	@State private var isShowRegistrationView = false
	
    var body: some View {
		VStack {
			buttonLoginEmail
			buttonCreateAccount
			
		}
		.padding()
		.sheet(isPresented: $isShowLoginWithEmailView) {
			LogInWithEmailView()
		}
		.sheet(isPresented: $isShowRegistrationView) {
			RegistrationView()
		}
    }
	
	private var buttonLoginEmail: some View {
		Button("Sign in using email") {
			isShowLoginWithEmailView = true
		}
		.buttonBorderShape(.capsule)
		.buttonStyle(.borderedProminent)
	}
	
	private var buttonCreateAccount: some View {
		Button("Create an account") {
			isShowRegistrationView = true
		}
	}
	
}

#Preview {
    LoginView()
}
