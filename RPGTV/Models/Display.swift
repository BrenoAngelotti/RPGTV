//
//  Display.swift
//  RPGTV
//
//  Created by Breno Gregorio Angelotti on 05/06/25.
//

import CoreGraphics
import Foundation
import SwiftData
import AppKit

@Model
class Display {
    var name: String
    /// In millimiters
    var size: Size
    var resolution: Size
    
    init(name: String, size: Size, resolution: Size) {
        self.name = name
        self.size = size
        self.resolution = resolution
    }
    
    var gridSize: Size {
        let inch = Measurement(value: 1, unit: UnitLength.inches).converted(to: .millimeters)
        
        let xSpace = (resolution.cgSize.width / inch.value) * resolution.cgSize.width
        let ySpace = (resolution.cgSize.width / inch.value) * resolution.cgSize.width
        
        return .init(.init(width: xSpace, height: ySpace))
    }
    
    static let iPadTesting: Display = {
        return Display(name: "iPad Air 4th gen", size: .init(.init(width: 398.4658536585, height: 192.4220338983)), resolution: .init(.init(width: 2360, height: 1640)))
    }()
    
    static let current: Display = {
        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen found")
            return Display(name: "none", size: .zero, resolution: .zero)
        }
        
        return Display(name: "Main", size: .init(.init(width: 400, height: 600)), resolution: .init(mainScreen.frame.size))
    }()
}
