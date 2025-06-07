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
    
    @Query private var maps: [Map]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(maps) { map in
					NavigationLink {
						ConfigureMapView(map: map)
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
			modelContext.insert(Map.mock)
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
