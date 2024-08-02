//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 02/08/24.
//
import PencilKit
import SwiftUI

struct CanvasView: UIViewRepresentable {
	@Binding var canvas: PKCanvasView
	@Binding var drawing: Bool
	@Binding var type: PKInkingTool.InkType
	@Binding var backgroundImage: UIImage?
	@Binding var isToolPickerVisible: Bool

	var ink : PKInkingTool {
		 PKInkingTool(type, color: UIColor(Color.black))
	}
	
	var eraser = PKEraserTool(.bitmap)
	
	func makeUIView(context: Context) -> PKCanvasView {
		canvas.tool = PKInkingTool(.pen, color: .black, width: 15)
		canvas.becomeFirstResponder()
		canvas.drawingPolicy = .anyInput
		canvas.isOpaque = false
		updateBackgroundImage(on: canvas)
		canvas.tool = drawing ? ink : eraser
		return canvas
	}
	
	func updateUIView(_ uiView: PKCanvasView, context: Context) {
		uiView.tool = drawing ? ink : eraser
		updateBackgroundImage(on: canvas)
	}
	
	private func updateBackgroundImage(on canvasView: PKCanvasView) {
			if let bgImage = backgroundImage {
				if let imageView = canvasView.subviews.compactMap({ $0 as? UIImageView }).first {
					imageView.image = bgImage
				} else {
					let imageView = UIImageView(image: bgImage)
					imageView.frame = canvasView.bounds
					imageView.contentMode = .scaleAspectFit
					imageView.translatesAutoresizingMaskIntoConstraints = true
					canvasView.insertSubview(imageView, at: 0)
				}
			}
		}
	
	func saveDrawing() -> UIImage? {
			guard let backgroundImage = backgroundImage else { return nil }
			UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, false, 0)
			backgroundImage.draw(in: CGRect(origin: .zero, size: canvas.bounds.size))
			
			if let context = UIGraphicsGetCurrentContext() {
				canvas.drawing.image(from: canvas.bounds, scale: UIScreen.main.scale).draw(in: canvas.bounds)
			}
			
			let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return combinedImage
		}
}

//#Preview {
//	CanvasView()
//}
