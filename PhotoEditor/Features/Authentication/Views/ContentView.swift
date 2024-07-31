//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var authManager: AuthManager
    var body: some View {
		NavigationStack {
			VStack {
				if authManager.authState != .signedOut {
					PhotoEditorView()
				} else {
					LoginView()
				}
			}
		}
    }
}

#Preview {
    ContentView()
}
