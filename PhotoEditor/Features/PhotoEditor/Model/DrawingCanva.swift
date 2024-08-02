//
//  DrawingCanva.swift
//  PhotoEditor
//
//  Created by Margarita Mayer on 02/08/24.
//

import Foundation
import PencilKit
import SwiftUI

struct DrawingCanva {
	var canvas = PKCanvasView()
	var drawing = false
	var color: Color = .black
	var type: PKInkingTool.InkType = .pen
}
