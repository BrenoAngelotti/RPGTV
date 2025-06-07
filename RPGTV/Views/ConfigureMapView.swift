//
//  ConfigureMapView.swift
//  RPGTV
//
//  Created by Breno Angelotti on 06/06/25.
//

import SwiftUI

struct ConfigureMapView: View {
	@Environment(\.openWindow) private var openWindow
	var map: Map?
	
	@State private var isSettingGrid = false
	@State private var isMoving = false
	@State private var offset = CGSize.zero
	
    var body: some View {
		VStack {
			ZStack {
				if let map, let image = map.image, let nsImage = image.nsImage {
					Image(nsImage: nsImage)
						.resizable()
						.scaledToFit()
				}
				
				if isSettingGrid {
					Rectangle()
						.frame(width: 50, height: 50, alignment: .center)
						.offset(offset)
						.gesture(
							DragGesture()
								.onChanged { gesture in
									offset = gesture.translation
								}
							
						)
				}
			}
		}
		.frame(minWidth: 600, minHeight: 400, alignment: .center)
		.toolbar {
			if let map {
				ToolbarItem(placement: .primaryAction) {
					Button {
						openWindow(value: map.id)
					} label: {
						Label("Open on display", systemImage: "display.2")
					}
				}
				
				ToolbarItem(placement: .secondaryAction) {
					Button {
						isSettingGrid.toggle()
					} label: {
						Label("Set grid scale", systemImage: "grid")
					}
				}
				
				ToolbarItem(placement: .secondaryAction) {
					Button {
						isMoving.toggle()
					} label: {
						Label("Move visible area", systemImage: "camera.viewfinder")
					}
				}
			}
		}
    }
}

#Preview {
	ConfigureMapView(map: .mock)
}
