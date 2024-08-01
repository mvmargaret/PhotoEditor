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
