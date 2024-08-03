//
//  PhotoEditorViewModel.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 02/08/24.
//
import Combine
import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation
import PencilKit
import PhotosUI
import SwiftUI


final class PhotoEditorViewModel: ObservableObject {
	@Published var showingFilters = false
	@Published var editableImage = EditableImage()
	@Published var drawingCanva = DrawingCanva()
	@Published var isToolPickerVisible = false
	let context = CIContext()
	private var currentRotationAngle: CGFloat = 0
	
	
	func changeFilter() {
		DispatchQueue.main.async {
			self.showingFilters = true
		}
	}
	
	
	func setFilter(_ filter: CIFilter) {
		DispatchQueue.main.async {
			self.editableImage.currentFilter = filter
		}
		loadImage()
	}
	
	
	func loadImage() {
		Task {
			guard let imageData = try await editableImage.selectedItem?.loadTransferable(type: Data.self) else { return }
			guard let inputImage = UIImage(data: imageData) else { return }

			let beginImage = CIImage(image: inputImage)
			editableImage.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
			DispatchQueue.main.async {
				self.editableImage.backgroundUIImage = inputImage
			}
			applyProcessing()
		}
	}
	
	
	func applyProcessing() {
		let inputKeys = self.editableImage.currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) { self.editableImage.currentFilter.setValue(self.editableImage.filterIntensity, forKey: kCIInputIntensityKey) }
		if inputKeys.contains(kCIInputRadiusKey) { self.editableImage.currentFilter.setValue(self.editableImage.filterIntensity * 200, forKey: kCIInputRadiusKey) }
		if inputKeys.contains(kCIInputScaleKey) { self.editableImage.currentFilter.setValue(self.editableImage.filterIntensity * 10, forKey: kCIInputScaleKey) }
		
		guard let outputImage = self.editableImage.currentFilter.outputImage else { return }
		guard let cgImage = self.context.createCGImage(outputImage, from: outputImage.extent) else { return }
		
		let uiImage = UIImage(cgImage: cgImage)
		DispatchQueue.main.async {
			self.editableImage.backgroundImage = Image(uiImage: uiImage)
			self.editableImage.backgroundUIImage = uiImage
		}
	}
	
	func rotateImage() {
			currentRotationAngle += CGFloat.pi / 2
		guard let outputImage = editableImage.currentFilter.outputImage else { return }
			let rotatedImage = outputImage.transformed(by: CGAffineTransform(rotationAngle: currentRotationAngle))
			guard let cgImage = context.createCGImage(rotatedImage, from: rotatedImage.extent) else { return }
			let uiImage = UIImage(cgImage: cgImage)
			DispatchQueue.main.async {
				self.editableImage.backgroundImage = Image(uiImage: uiImage)
				self.editableImage.backgroundUIImage = uiImage
			}
		}
	
	func showToolPicker(_ canvasView: PKCanvasView) {
		drawingCanva.canvas = canvasView
		drawingCanva.toolPicker.setVisible(true, forFirstResponder: drawingCanva.canvas)
		drawingCanva.toolPicker.addObserver(drawingCanva.canvas)
	  }

	  func hideToolPicker() {
		  drawingCanva.toolPicker.setVisible(false, forFirstResponder: drawingCanva.canvas)
		  drawingCanva.toolPicker.removeObserver(drawingCanva.canvas)
	  }
	
	func toggleToolPicker(_ canvasView: PKCanvasView) {
			isToolPickerVisible.toggle()
			if isToolPickerVisible {
				showToolPicker(canvasView)
				drawingCanva.drawing = true
			} else {
				hideToolPicker()
				drawingCanva.drawing = false
			}
		}
	
	func saveDrawnImage() {
		guard let backgroundUIImage = editableImage.backgroundUIImage else { return }
		UIGraphicsBeginImageContextWithOptions(drawingCanva.canvas.bounds.size, false, 0)
		backgroundUIImage.draw(in: CGRect(origin: .zero, size: drawingCanva.canvas.bounds.size))
		
		if let context = UIGraphicsGetCurrentContext() {
			drawingCanva.canvas.drawing.image(from: drawingCanva.canvas.bounds, scale: UIScreen.main.scale).draw(in: drawingCanva.canvas.bounds)
		}
		
		if let combinedImage = UIGraphicsGetImageFromCurrentImageContext() {
			UIGraphicsEndImageContext()
			
			DispatchQueue.main.async {
				self.editableImage.backgroundImage = Image(uiImage: combinedImage)
				self.editableImage.backgroundUIImage = combinedImage
			}
		}
	}

}
