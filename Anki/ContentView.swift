//
//  ContentView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/16.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var errorHandling: ErrorHandling

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.front, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @State private var searchingText = ""
    @State private var showAddItemView = false
	
    @State private var navigationTitle = "Anki"
	
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
						EditItemView(item: item, saveUpdatedItem: saveUpdatedItem)
                    } label: {
                        VStack {
                            Text(item.front!)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("\(item.back!)")
                                .offset(x: 10)
                                .font(.body)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .searchable(text: $searchingText)
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination:
									PlayingView(openAddItemView: openAddItemView)
									.withErrorAlert()) {
                        Image(systemName: "play.fill")
					}
				}
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: openAddItemView) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
			}
			.onAppear(perform: {
                navigationTitle = "Anki"
            })
            .onDisappear(perform: {
                navigationTitle = "Menu"
            })
        }
        .sheet(isPresented: $showAddItemView) {
            AddItemView().withErrorAlert()
        }
    }

    private func saveUpdatedItem() {
		do {
			try viewContext.save()
		} catch {
			self.errorHandling.handleError(error: error)
		}
    }

    private func openAddItemView() {
        showAddItemView = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                self.errorHandling.handleError(error: error)
            }
        }
    }
}
