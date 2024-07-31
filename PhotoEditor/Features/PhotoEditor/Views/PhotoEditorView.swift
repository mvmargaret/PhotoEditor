//
//  PhotoEditorView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//

import SwiftUI

struct PhotoEditorView: View {
	@EnvironmentObject var authManager: AuthManager
    var body: some View {
		VStack {
			Text("There will be a photo editor view")
				.foregroundStyle(.red)
			
			Button("Sign out") {
				authManager.signOut()
			}
		}
    }
}

#Preview {
    PhotoEditorView()
}
