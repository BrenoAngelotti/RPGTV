//
//  Map.swift
//  RPGTV
//
//  Created by Breno Gregorio Angelotti on 05/06/25.
//

import SwiftData
import CoreGraphics

@Model
class Map {
    var name: String
    var image: MapImage?
    
    init(name: String, image: MapImage? = nil) {
        self.name = name
        self.image = image
    }
}
