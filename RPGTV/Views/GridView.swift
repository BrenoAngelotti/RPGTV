//
//  GridView.swift
//  RPGTV
//
//  Created by Breno Gregorio Angelotti on 06/06/25.
//

import SwiftUI

struct GridView: View {
    var display: Display
    var origin: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let horizontalLines = Int(geometry.size.width / display.gridSize.width)
                let verticalLines = Int(geometry.size.height / display.gridSize.height)
                
                for line in Int(origin.x)...horizontalLines {
                    let x = display.gridSize.width * CGFloat(line)
                    path.move(to: .init(x: x, y: .zero))
                    path.addLine(to: .init(x: x, y: CGFloat(verticalLines)*display.gridSize.width))
                }
                for line in Int(origin.y)...verticalLines {
                    let y = display.gridSize.height * CGFloat(line)
                    path.move(to: .init(x: .zero, y: y))
                    path.addLine(to: .init(x: CGFloat(horizontalLines)*display.gridSize.height, y: y))
                }
            }.stroke()
        }
    }
}

#Preview {
    GridView(display: .iPadTesting)
}
