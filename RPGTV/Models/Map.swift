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
	
	static let mock: Map = {
		let image = NSImage(resource: .testMap).tiffRepresentation!
		return Map(name: "Test Map", image: MapImage(data: image, scale: 1))
	}()
}
