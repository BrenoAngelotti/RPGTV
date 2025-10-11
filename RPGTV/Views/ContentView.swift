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
	@State private var isShowingFileImporter = false
	
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
					Button(action: { isShowingFileImporter.toggle() }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
			.fileImporter(isPresented: $isShowingFileImporter,
						  allowedContentTypes: [.image],
						  allowsMultipleSelection: false) { result in
				switch result {
				case .success(let urls):
					for url in urls {
						addMap(withUrl: url)
					}
				case .failure(let error):
					print("File selection error: \(error.localizedDescription)")
				}
			}
        } detail: {
            Text("Select a map")
        }
    }

	private func addMap(withUrl url: URL) {
        withAnimation {
			if url.startAccessingSecurityScopedResource() {
				modelContext.insert(Map(named: "Sample", fromUrl: url))
			}
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
