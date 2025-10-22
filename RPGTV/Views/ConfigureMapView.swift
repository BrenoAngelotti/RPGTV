//
//  ConfigureMapView.swift
//  RPGTV
//
//  Created by Breno Angelotti on 06/06/25.
//

import SwiftUI

struct ConfigureMapView: View {
	@Environment(\.openWindow) private var openWindow
	@Environment(\.modelContext) var modelContext
	
	var map: Map?
	
	@State private var isEditingGrid = false
	@State private var isDrawingGrid = false
	@State private var isMoving = false
	
	@State private var isVisible = false
	
	@State private var gridPlacement = CGRect.zero
	
	@State private var movingOffset = CGPoint.zero
	@State private var offset = CGPoint.zero
	
	@State private var visibleAreaMovingOffset = CGPoint.zero
	@State private var visibleAreaOffset = CGPoint.zero
	
	@State private var movingScale = CGFloat(1)
	@State private var currentScale = CGFloat(1)
	
    var body: some View {
		VStack {
			ZStack {
				GeometryReader { geometry in
					Image(nsImage: map!.image!.nsImage!)
						.scaleEffect(movingScale)
						.position(movingOffset)
						.onAppear {
							visibleAreaOffset = .init(x: geometry.size.height / 2, y: geometry.size.height / 2)
						}
							
					if isDrawingGrid {
						Rectangle()
							.stroke(style: StrokeStyle(lineWidth: 2, lineCap: .square, lineJoin: .bevel, miterLimit: 0, dash: [5], dashPhase: 5))
							.frame(width: gridPlacement.width, height: gridPlacement.height)
							.position(.init(x: gridPlacement.midX, y: gridPlacement.midY))
					} else if !isEditingGrid {
						Rectangle()
							.frame(width: 100, height: 100)
							.position(visibleAreaMovingOffset)
							.gesture(DragGesture()
								.onChanged { value in
									visibleAreaMovingOffset = CGPoint(x: visibleAreaOffset.x + value.translation.width, y: visibleAreaOffset.y + value.translation.height)
								}
								.onEnded { value in
									visibleAreaOffset = visibleAreaMovingOffset
									updateVisibleArea()
								}
							)
					}
				}
			}
			.gesture(
				DragGesture()
					.onChanged({ value in
						if isEditingGrid {
							
							isDrawingGrid = true
							
							let side = min(abs(value.translation.width), abs(value.translation.height))
							let widthSign = value.translation.width >= 0 ? 1.0 : -1.0
							let heightSign = value.translation.height >= 0 ? 1.0 : -1.0
							let square = CGSize(width: side * widthSign, height: side * heightSign)
							
							gridPlacement = .init(origin: value.startLocation, size: square)
						} else {
							movingOffset = CGPoint(x: offset.x + value.translation.width, y: offset.y + value.translation.height)
							visibleAreaMovingOffset = CGPoint(x: visibleAreaOffset.x + value.translation.width, y: visibleAreaOffset.y + value.translation.height)
						}
					})
					.onEnded({ value in
						if isEditingGrid {
							isDrawingGrid = false
							isEditingGrid = false
							updateMap(currentScale: currentScale)
						} else {
							offset = movingOffset
							visibleAreaOffset = visibleAreaMovingOffset
						}
					})
			)
			.gesture(MagnifyGesture(minimumScaleDelta: 0.1)
				.onChanged { value in
					movingScale = currentScale * value.magnification
				}
				.onEnded { value in
					currentScale = movingScale
				}
			)
		}
		.toolbar {
			if let map {
				ToolbarItem(placement: .primaryAction) {
					Button {
						openWindow(value: map.id)
					} label: {
						Label("Open in window", systemImage: "display.2")
					}
				}
				
				ToolbarItem(placement: .principal) {
					Toggle(isOn: $isEditingGrid) {
						Label("Measure scale", systemImage: "ruler")
					}
				}
				
				ToolbarItem(placement: .principal) {
					Button {
						isVisible.toggle()
						setVisibility()
					} label: {
						Label(isVisible ? "Hide map" : "Show map", systemImage: isVisible ? "eye.slash" : "eye")
							.contentTransition(.symbolEffect(.replace))
					}
				}
			}
		}
    }
	
	private func setVisibility() {
		map?.image?.isVisible = isVisible
		try? modelContext.save()
	}
	
	private func updateVisibleArea() {
		map?.image?.origin = .init(.init(
			x: offset.x - visibleAreaOffset.x,
			y: offset.y - visibleAreaOffset.y
		))
		try? modelContext.save()
	}
	
	private func updateMap(currentScale: CGFloat) {
		map?.image?.ppi = gridPlacement.height / currentScale
		try? modelContext.save()
	}
}

#Preview {
	let mock: Map = {
		let image = NSImage(resource: .testMap).tiffRepresentation!
		return Map(name: "Test Map", image: MapImage(data: image, ppi: 80))
	}()
	
	return ConfigureMapView(map: mock)
}
