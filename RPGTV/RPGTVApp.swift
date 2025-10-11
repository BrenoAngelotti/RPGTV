//
//  RPGTVApp.swift
//  RPGTV
//
//  Created by Breno Gregorio Angelotti on 05/06/25.
//

import SwiftUI
import SwiftData

@main
struct RPGTVApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Map.self,
            Display.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        
        WindowGroup("Auxilary display", for: Map.ID.self) { $mapId in
			OpenMapView(mapId: mapId, display: .fixedTvTesting)
        }
        .modelContainer(sharedModelContainer)
		.windowResizability(.contentMinSize)
    }
}
