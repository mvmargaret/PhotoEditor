//
//  PhotoEditorView.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 31/07/24.
//

import SwiftUI
import PencilKit
import PhotosUI

struct PhotoEditorView: View {
	@EnvironmentObject var authManager: AuthManager
	@Environment(\.undoManager) var undoManager
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
				ToolbarItem(placement: .topBarTrailing) {
					Button("Выйти") {
						authManager.signOut()
						authManager.googleSignOut()
					}
				}
				ToolbarItemGroup {
					drawingButtons
				}
			}
		}
	}
	
	@ViewBuilder
	private var processedImage: some View {
		PhotosPicker(selection: $photoViewModel.selectedItem) {
			if let  processedImage = photoViewModel.processedImage {
				ZStack {
					processedImage
						.resizable()
						.scaledToFit()
					CanvasView(canvas: $photoViewModel.drawingCanva.canvas, drawing: $photoViewModel.drawingCanva.drawing, type: $photoViewModel.drawingCanva.type, backgroundImage: $photoViewModel.backgroundUIImage, isToolPickerVisible: $photoViewModel.isToolPickerVisible)
				}
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
		} else {
			HStack {
				Image(systemName: "square.and.arrow.up")
				Text("Share...")
			}
			.foregroundStyle(.gray.opacity(0.6))
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
		.disabled(photoViewModel.selectedItem == nil)
	}
	
	@ViewBuilder
	private var drawingButtons: some View {
		Button("Save")  {
			photoViewModel.saveDrawnImage()
		}
		.disabled(photoViewModel.selectedItem == nil)
		Button { undoManager?.undo() } label: {
			Image(systemName: "arrow.uturn.backward.circle")
		}
		.disabled(photoViewModel.selectedItem == nil)
		
		Button { undoManager?.redo() } label: {
			Image(systemName: "arrow.uturn.forward.circle")
		}
		.disabled(photoViewModel.selectedItem == nil)
		
		Button(action: {
			photoViewModel.toggleToolPicker(photoViewModel.drawingCanva.canvas)
		}) {
			Image(systemName: photoViewModel.isToolPickerVisible ? "pencil.slash"  : "pencil.and.outline")
		}
		.disabled(photoViewModel.selectedItem == nil)
	}
}

#Preview {
    PhotoEditorView()
}
