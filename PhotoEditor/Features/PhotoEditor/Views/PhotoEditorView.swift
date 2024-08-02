//
//  PhotoEditorView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//

import SwiftUI
import PhotosUI

struct PhotoEditorView: View {
	@EnvironmentObject var authManager: AuthManager
	@StateObject var photoViewModel = PhotoEditorViewModel()
	
	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				processedImage
				Spacer()
				intensitySlider
				HStack {
					filters
					Spacer()
					rotateButton
					Spacer()
					shareLink
				}
			}
			.padding([.horizontal, .bottom])
			.navigationTitle("PhotoEditor")
			.confirmationDialog("Select a filter", isPresented: $photoViewModel.showingFilters) {
				filterButtons
			}
			.toolbar {
				Button("Выйти") {
					authManager.signOut()
					authManager.googleSignOut()
				}
			}
		}
	}
	
	@ViewBuilder
	private var processedImage: some View {
		PhotosPicker(selection: $photoViewModel.selectedItem) {
			if let  processedImage = photoViewModel.processedImage {
				processedImage
					.resizable()
					.scaledToFit()
			} else {
				ContentUnavailableView("Нет фото", systemImage: "photo.badge.plus", description: Text("Нажмите, чтобы загрузить фото"))
			}
		}
		.onChange(of: photoViewModel.selectedItem, photoViewModel.loadImage)
	}
	
	private var intensitySlider: some View {
		HStack {
			Text("Интенсивность")
			Slider(value: $photoViewModel.filterIntensity)
				.onChange(of: photoViewModel.filterIntensity, photoViewModel.applyProcessing)
				.disabled(photoViewModel.selectedItem == nil)
		}
		.padding(.vertical)
	}
	
	private var filters: some View {
		Button("Фильтры") {
			photoViewModel.changeFilter()
		}
		.disabled(photoViewModel.selectedItem == nil)
	}
	
	@ViewBuilder
	private var shareLink: some View {
		if let processedImage = photoViewModel.processedImage {
			ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
		}
	}
	
	private var filterButtons: some View {
		Group {
			Button("Crystallize") {photoViewModel.setFilter(CIFilter.crystallize()) }
			Button("Gaussian Blur") { photoViewModel.setFilter(CIFilter.gaussianBlur()) }
			Button("Pixellate") { photoViewModel.setFilter(CIFilter.pixellate()) }
			Button("Sepia Tone") { photoViewModel.setFilter(CIFilter.sepiaTone()) }
			Button("Unsharp Mask") { photoViewModel.setFilter(CIFilter.unsharpMask()) }
			Button("Vignette") { photoViewModel.setFilter(CIFilter.vignette()) }
			Button("Cancel", role: .cancel) { }
		}
	}
	
	private var rotateButton: some View {
		Button("Повернуть") {
			photoViewModel.rotateImage()
		}
	}
}

#Preview {
    PhotoEditorView()
}
