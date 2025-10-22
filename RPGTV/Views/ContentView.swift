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
	@State private var isShowingMapNameDialog = false
	
	@State private var mapName = ""
	@State private var mapURL: URL?
	
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
					mapURL = urls.first
					isShowingMapNameDialog.toggle()
				case .failure(let error):
					print("File selection error: \(error.localizedDescription)")
				}
			}
			.alert("Map name", isPresented: $isShowingMapNameDialog) {
				TextField("Name", text: $mapName)
				Button("OK") {
					addMap()
				}
				Button("Cancel", role: .cancel) {}
			}
        } detail: {
            Text("Select a map")
        }
    }

	private func addMap() {
		guard let mapURL else { return }
        withAnimation {
			if mapURL.startAccessingSecurityScopedResource() {
				modelContext.insert(Map(named: mapName.isEmpty ? "New map" : mapName, fromUrl: mapURL))
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
