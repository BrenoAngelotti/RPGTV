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
    var display: Display = .iPadTesting
    
    var body: some View {
        ZStack {
            if let map, let image = map.image, let nsImage = image.nsImage {
                Image(nsImage: nsImage)
                    .scaleEffect(image.scale)
                
                GridView(display: display, origin: image.origin.cgPoint)
            }
        }
        .frame(minWidth: 600, minHeight: 400, alignment: .center)
        .navigationTitle(map?.name ?? "New map")
    }
}

#Preview {
    let image = NSImage(resource: .testMap).tiffRepresentation!
    let map = Map(name: "New Map", image: MapImage(data: image, scale: 0.1))
    
    OpenMapView(mapId: map.id)
}
