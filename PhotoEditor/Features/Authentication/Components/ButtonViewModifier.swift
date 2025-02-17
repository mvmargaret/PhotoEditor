//
//  ButtonViewModifier.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 01/08/24.
//

import Foundation
import SwiftUI

struct MainButton: View {
	let title: String
	let action: () -> Void
	let color: Color
	let width = UIScreen.main.bounds.width
	var image: String? = nil
	var logo: String? = nil

	var body: some View {
		Button(action: action) {
			HStack {
				if let image = image {
					Image(systemName: image)
				}
				if let logo = logo {
					Image("\(logo)")
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25)
				}
				Spacer()
				Text(title)
				Spacer()
			}
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
