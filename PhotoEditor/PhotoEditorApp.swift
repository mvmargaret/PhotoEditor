//
//  PhotoEditorApp.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 30/07/24.
//
import GoogleSignIn
import SwiftUI
import UIKit
import FirebaseCore
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
				   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
	return true
  }
	func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
		  return GIDSignIn.sharedInstance.handle(url)
		}
}

@main
struct PhotoEditorApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	@StateObject var authManager: AuthManager
	
	init() {
		 FirebaseApp.configure()
		
		let authManager = AuthManager()
		_authManager = StateObject(wrappedValue: authManager)
	 }
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(authManager)
        }
    }
}
