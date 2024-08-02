//
//  EditableImage.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 02/08/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct EditableImage {
	var backgroundImage: Image?
	var backgroundUIImage: UIImage?
	var selectedItem: PhotosPickerItem?
	var currentFilter: CIFilter = CIFilter.sepiaTone()
	var filterIntensity = 0.5
}
