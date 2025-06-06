//
//  ContentView.swift
//  RPGTV
//
//  Created by Breno Gregorio Angelotti on 05/06/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openWindow) private var openWindow
    @Query private var maps: [Map]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(maps) { map in
                    NavigationLink {
                        Button {
                            openWindow(value: map.id)
                        } label: {
                            Label("Open on display", systemImage: "display.2")
                        }
                    } label: {
                        Text(map.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let image = NSImage(resource: .testMap).tiffRepresentation!
            let map = Map(name: "Test Map", image: MapImage(data: image, scale: 1))
            
            modelContext.insert(map)
            try? modelContext.save()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(maps[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Map.self, inMemory: true)
}
