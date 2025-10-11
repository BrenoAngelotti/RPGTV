//
//  OpenMapView.swift
//  RPGTV
//
//  Created by Breno Gregorio Angelotti on 05/06/25.
//

import SwiftUI
import SwiftData

struct OpenMapView: View {
    @Environment(\.modelContext) var modelContext
    
    var mapId: PersistentIdentifier? = nil
    var map: Map? {
        guard let mapId, let map = modelContext.model(for: mapId) as? Map else { return nil }
        return map
    }
	var display: Display = .fixedTvTesting
    
    var body: some View {
        ZStack {
            if let map, let image = map.image, let nsImage = image.nsImage {
				GeometryReader { geometry in
					Image(nsImage: nsImage)
						.scaleEffect(1 / (image.ppi / display.ppi))
						.position(.init(x: geometry.size.width / 2 + map.image!.origin.cgPoint.x, y: geometry.size.height / 2 + map.image!.origin.cgPoint.y))
						.overlay {
							if map.image?.isVisible == false {
								Rectangle()
									.scaledToFill()
									.foregroundStyle(Color.black)
							}
						}
				}
            }
        }
		.frame(minWidth: display.size.width, minHeight: display.size.height, alignment: .center)
        .navigationTitle(map?.name ?? "New map")
    }
}

#Preview {
    let image = NSImage(resource: .testMap).tiffRepresentation!
    let map = Map(name: "New Map", image: MapImage(data: image, ppi: 80))
    
    OpenMapView(mapId: map.id)
}
