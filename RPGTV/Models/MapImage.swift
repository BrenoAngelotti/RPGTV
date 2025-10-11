//
//  MapImage.swift
//  RPGTV
//
//  Created by Breno Gregorio Angelotti on 05/06/25.
//

import CoreGraphics
import Foundation
import SwiftUI

struct MapImage: Codable {
    var data: Data?
    var origin: Point = .zero
    var ppi: Double = 1.0
	var isVisible: Bool = false
    
    var nsImage: NSImage? {
        guard
            let data,
            let nsImage = NSImage(data: data)
        else { return nil }
        
        return nsImage
    }
}
