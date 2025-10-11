//
//  Map.swift
//  RPGTV
//
//  Created by Breno Gregorio Angelotti on 05/06/25.
//

import AppKit
import CoreGraphics
import SwiftData

@Model
class Map {
    var name: String
    var image: MapImage?
    
    init(name: String, image: MapImage? = nil) {
        self.name = name
        self.image = image
    }
	
	init(named name: String, fromUrl url: URL) {
		let image = NSImage(contentsOf: url)?.tiffRepresentation
		self.name = name
		self.image = MapImage(data: image)
	}
}
