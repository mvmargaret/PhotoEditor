//
//  AuthManager.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//
import AuthenticationServices
import GoogleSignIn
import Foundation
import Firebase
import FirebaseAuth

enum AuthState {
	case signedIn
	case signedOut
}

class AuthManager: ObservableObject {
//	@Published var user: User?
	@Published var authState = AuthState.signedOut
	@Published var email = ""
	@Published var password = ""
	@Published var currentError: Error?
	
	
	init() {
		  observeAuthState()
	  }
	
	func observeAuthState() {
		Auth.auth().addStateDidChangeListener() { auth, user in
			DispatchQueue.main.async {
				if user != nil {
					self.authState = .signedIn
					print("Auth state changed, is signed in")
				} else {
					self.authState = .signedOut
					print("Auth state changed, is signed out")
				}
			}
		}
	}
	func login(completion: @escaping (Result<Void, Error>) -> Void) {
		Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
			if let error = error {
				print(error.localizedDescription)
				completion(.failure(error))
			} else {
				print("successfully logged in user with email: \(self.email), password: \(self.password)")
				completion(.success(()))
			}
		}
	}
	
	func createAccount(completion: @escaping (Result<Void, Error>) -> Void) {
		Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
			if let error = error {
				print(error.localizedDescription)
				completion(.failure(error))
			} else {
				self.sendVerificationEmail()
				completion(.success(()))
				print("successfully created a new user with email: \(self.email), password: \(self.password)")
			}
		}
	}
	
	func signOut() {
		let firebaseAuth = Auth.auth()
		do {
		  try firebaseAuth.signOut()
			print("User signed out")
		} catch let signOutError as NSError {
		  print("Error signing out: %@", signOutError)
		}
	}
	
	func resetPassword(completion: @escaping (Result<Void, Error>) -> Void) {
		Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
				if let error = error {
					print("Error with reset password: \(error.localizedDescription)")
					completion(.failure(error))
				} else {
					completion(.success(()))
				}
		}
	}
	
	func sendVerificationEmail() {
		Auth.auth().currentUser?.sendEmailVerification { error in
			print("Coudnt send the link because the email is incorrect. Error: \(String(describing: error?.localizedDescription))")
		}
	}
	
	func signInWithGoogle(presentingViewController: UIViewController) {
		guard let clientID = FirebaseApp.app()?.options.clientID else { return }
				
		let config = GIDConfiguration(clientID: clientID)

		GIDSignIn.sharedInstance.configuration = config
				
		GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signResult, error in
					
			if let error = error {
				print("Error with sign in Google: \(error.localizedDescription)")
			   return
			}
					
			 guard let user = signResult?.user,
				   let idToken = user.idToken else { return }
			 
			 let accessToken = user.accessToken
					
			 let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

			// Use the credential to authenticate with Firebase
			Auth.auth().signIn(with: credential) { authResult, error in
				if let error = error {
					print("Firebase sign-in error: \(error.localizedDescription)")
				} else {
					print("Successfully signed in with Google")
				}
			}

		}

	}
	
	func googleSignOut() {
		GIDSignIn.sharedInstance.signOut()
		print("Google sign out")
	}
}
