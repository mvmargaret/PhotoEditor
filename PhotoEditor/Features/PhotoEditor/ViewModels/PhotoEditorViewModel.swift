//
//  PhotoEditorViewModel.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 02/08/24.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation
import PhotosUI
import SwiftUI


class PhotoEditorViewModel: ObservableObject {
	@Published var processedImage: Image?
	@Published var filterIntensity = 0.5
	@Published var selectedItem: PhotosPickerItem?
	@Published var currentFilter: CIFilter = CIFilter.sepiaTone()
	let context = CIContext()
	@Published var showingFilters = false
	private var currentRotationAngle: CGFloat = 0
	
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
}
