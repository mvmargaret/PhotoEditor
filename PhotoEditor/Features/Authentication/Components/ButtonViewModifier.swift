//
//  ButtonViewModifier.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 01/08/24.
//

import Foundation
import SwiftUI

struct ButtonViewModifier: ViewModifier {
	var color: Color
	
	func body(content: Content) -> some View {
			content
				.frame(maxWidth: .infinity)
				.padding(.horizontal, 50)
				.buttonBorderShape(.capsule)
				.buttonStyle(.borderedProminent)
				.tint(color)
				
	}
}

extension View {
	func buttonStyle(color: Color) -> some View {
		modifier(ButtonViewModifier(color: color))
	}
}

struct MainButton: View {
	let title: String
	let action: () -> Void
	let color: Color
	let width = UIScreen.main.bounds.width

	var body: some View {
		Button(action: action) {
			Text(title)
			.frame(maxWidth: .infinity)
			.font(.system(.title3, design: .rounded))
			.padding(EdgeInsets(top: width * 0.03, leading: width * 0.1, bottom: width * 0.03, trailing: width * 0.1))
			.foregroundColor(.white)
			.background(color)
			.clipShape(Capsule())
		}
		.contentShape(Capsule())
	}
}
