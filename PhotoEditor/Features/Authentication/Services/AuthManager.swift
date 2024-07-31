//
//  AuthManager.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//

import Foundation
import FirebaseAuth

enum AuthState {
	case signedIn
	case signedOut
}

class AuthManager: ObservableObject {
	@Published var user: User?
	@Published var authState = AuthState.signedOut
	@Published var email = ""
	@Published var password = ""
	
	
	
	func login() {
		Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
			if error != nil {
				print(error?.localizedDescription ?? "")
			} else {
				print("successfully logged in user with email: \(self.email), password: \(self.password)")
			}
		}
	}
	
	func createAccount() {
		Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
			if error != nil {
				print(error?.localizedDescription ?? "")
			} else {
				print("successfully created a new user with email: \(self.email), password: \(self.password)")
			}
		}
	}
	
	func logOut() {
		
	}
	
	func resetPassword() {
		
	}
}
