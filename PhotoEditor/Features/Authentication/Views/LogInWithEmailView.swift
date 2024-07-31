//
//  LogInWithEmailView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//

import SwiftUI

struct LogInWithEmailView: View {
	@EnvironmentObject var authManager: AuthManager
	
    var body: some View {
		VStack {
			Form {
				Section("Enter your email and password") {
					TextField("Email", text: $authManager.email)
					SecureField("Password", text: $authManager.password)
				}
				
					Button("Sign in") {
						authManager.login()
					}
				
				Button("Sign out") {
					authManager.signOut()
				}
				
			}
		}
    }
}

#Preview {
    LogInWithEmailView()
}
