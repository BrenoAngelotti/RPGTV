//
//  TestCGSize.swift
//  RPGTV
//
//  Created by Breno Gregorio Angelotti on 06/06/25.
//

import CoreGraphics

struct Size: Codable {
    var cgSize: CGSize {
        get {
            .init(width: _cgSizeWidth, height: _cgSizeHeight)
        }
        set {
            self._cgSizeWidth = newValue.width
            self._cgSizeHeight = newValue.height
        }
    }
    
    var width: CGFloat {
        return _cgSizeWidth
    }
    
    var height: CGFloat {
        return _cgSizeHeight
    }
    
    // Columns created and data stored in db.
    private var _cgSizeWidth: Double = 0.0
    private var _cgSizeHeight: Double = 0.0
    
    init(_ cgSize: CGSize) {
        self.cgSize = cgSize
    }
	
	init(width: Double, height: Double) {
		self.cgSize = .init(width: width, height: height)
	}
    
    static let zero = Size(.zero)
}

struct Point: Codable {
    var cgPoint: CGPoint {
        get {
            .init(x: _cgPointX, y: _cgPointY)
        }
        set {
            self._cgPointX = newValue.x
            self._cgPointY = newValue.y
        }
    }
    
    var x: CGFloat {
        return _cgPointX
    }
    
    var y: CGFloat {
        return _cgPointY
    }
    
    // Columns created and data stored in db.
    private var _cgPointX: Double = 0.0
    private var _cgPointY: Double = 0.0
    
    init(_ cgPoint: CGPoint) {
        self.cgPoint = cgPoint
    }
    
    static let zero = Point(.zero)
}
