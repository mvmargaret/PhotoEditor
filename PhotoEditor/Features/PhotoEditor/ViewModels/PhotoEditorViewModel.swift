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
	@Published var processedImage: Image?
	@Published var filterIntensity = 0.5
	@Published var selectedItem: PhotosPickerItem?
	@Published var currentFilter: CIFilter = CIFilter.sepiaTone()
	@Published var showingFilters = false
	@Published var backgroundUIImage: UIImage?
	let context = CIContext()
	private var currentRotationAngle: CGFloat = 0
	
	let toolPicker = PKToolPicker()
	@Published var drawingCanva = DrawingCanva()
//	@Published var canvas = PKCanvasView()
//	@Published var drawing = false
//	@Published var color: Color = .black
//	@Published var type: PKInkingTool.InkType = .pen
	@Published var isToolPickerVisible = false
	
	
	func changeFilter() {
		DispatchQueue.main.async {
			self.showingFilters = true
		}
	}
	
	
	func setFilter(_ filter: CIFilter) {
		DispatchQueue.main.async {
			self.currentFilter = filter
		}
		loadImage()
	}
	
	
	func loadImage() {
		Task {
			guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
			guard let inputImage = UIImage(data: imageData) else { return }

			let beginImage = CIImage(image: inputImage)
			currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
			DispatchQueue.main.async {
				self.backgroundUIImage = inputImage
			}
			applyProcessing()
		}
	}
	
	
	func applyProcessing() {
		let inputKeys = self.currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) { self.currentFilter.setValue(self.filterIntensity, forKey: kCIInputIntensityKey) }
		if inputKeys.contains(kCIInputRadiusKey) { self.currentFilter.setValue(self.filterIntensity * 200, forKey: kCIInputRadiusKey) }
		if inputKeys.contains(kCIInputScaleKey) { self.currentFilter.setValue(self.filterIntensity * 10, forKey: kCIInputScaleKey) }
		
		guard let outputImage = self.currentFilter.outputImage else { return }
		guard let cgImage = self.context.createCGImage(outputImage, from: outputImage.extent) else { return }
		
		let uiImage = UIImage(cgImage: cgImage)
		DispatchQueue.main.async {
			self.processedImage = Image(uiImage: uiImage)
		}
	}
	
	func rotateImage() {
			currentRotationAngle += CGFloat.pi / 2
			guard let outputImage = currentFilter.outputImage else { return }
			let rotatedImage = outputImage.transformed(by: CGAffineTransform(rotationAngle: currentRotationAngle))
			guard let cgImage = context.createCGImage(rotatedImage, from: rotatedImage.extent) else { return }
			let uiImage = UIImage(cgImage: cgImage)
			DispatchQueue.main.async {
				self.processedImage = Image(uiImage: uiImage)
			}
		}
	
	func showToolPicker(_ canvasView: PKCanvasView) {
		drawingCanva.canvas = canvasView
		toolPicker.setVisible(true, forFirstResponder: drawingCanva.canvas)
		toolPicker.addObserver(drawingCanva.canvas)
	  }

	  func hideToolPicker() {
		  toolPicker.setVisible(false, forFirstResponder: drawingCanva.canvas)
		  toolPicker.removeObserver(drawingCanva.canvas)
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
		guard let backgroundImage = backgroundUIImage else { return }
		UIGraphicsBeginImageContextWithOptions(drawingCanva.canvas.bounds.size, false, 0)
		backgroundImage.draw(in: CGRect(origin: .zero, size: drawingCanva.canvas.bounds.size))
		
		if let context = UIGraphicsGetCurrentContext() {
			drawingCanva.canvas.drawing.image(from: drawingCanva.canvas.bounds, scale: UIScreen.main.scale).draw(in: drawingCanva.canvas.bounds)
		}
		
		if let combinedImage = UIGraphicsGetImageFromCurrentImageContext() {
			UIGraphicsEndImageContext()
			
			DispatchQueue.main.async {
				self.processedImage = Image(uiImage: combinedImage)
			}
		}
	}

}
