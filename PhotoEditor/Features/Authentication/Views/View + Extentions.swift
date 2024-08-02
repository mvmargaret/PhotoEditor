//
//  View + Extentions.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 01/08/24.
//

import Foundation
import SwiftUI

extension View {
	func errorAlert(isPresented: Binding<Bool>, buttonTitle: String = "OK", message: String) -> some View {
		return alert("An error has occured", isPresented: isPresented) {
				Button(buttonTitle) {}
			} message: {
				Text(message)
			}
	}
}

extension View {
	func getRootViewController() -> UIViewController {
		guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
			return .init()
		}

		guard let root = screen.windows.first?.rootViewController else {
			return .init()
		}
		

		return root
	}
}
