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

				HStack {
					Text("Интенсивность")
					Slider(value: $photoViewModel.filterIntensity)
						.onChange(of: photoViewModel.filterIntensity, photoViewModel.applyProcessing)
				}
				.padding(.vertical)

				HStack {
					Button("Фильтры") {
						photoViewModel.changeFilter()
					}

					Spacer()

					shareLink
				}
				Button("Выйти") {
					authManager.signOut()
					authManager.googleSignOut()
				}
			}
			.padding([.horizontal, .bottom])
			.navigationTitle("PhotoEditor")
			.confirmationDialog("Select a filter", isPresented: $photoViewModel.showingFilters) {
				Button("Crystallize") {photoViewModel.setFilter(CIFilter.crystallize()) }
				Button("Gaussian Blur") { photoViewModel.setFilter(CIFilter.gaussianBlur()) }
				Button("Pixellate") { photoViewModel.setFilter(CIFilter.pixellate()) }
				Button("Sepia Tone") { photoViewModel.setFilter(CIFilter.sepiaTone()) }
				Button("Unsharp Mask") { photoViewModel.setFilter(CIFilter.unsharpMask()) }
				Button("Vignette") { photoViewModel.setFilter(CIFilter.vignette()) }
				Button("Cancel", role: .cancel) { }
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
	
	@ViewBuilder
	private var shareLink: some View {
		if let processedImage = photoViewModel.processedImage {
			ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
		}
	}
}

#Preview {
    PhotoEditorView()
}
