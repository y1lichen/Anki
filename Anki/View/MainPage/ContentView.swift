//
//  ContentView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/16.
//

import CoreData
import SwiftUI

struct ContentView: View {
	
	@AppStorage("schemeMode") private var schemeMode = 0
	
    @EnvironmentObject var errorHandling: ErrorHandling

	@StateObject var viewModel = ItemViewModel()

    @State private var searchingText = ""
    @State private var showAddItemView = false
	
    @State private var navigationTitle = "Anki"
	
    var body: some View {
        NavigationView {
            List {
				ForEach(viewModel.items) { item in
                    NavigationLink {
						EditItemView(item: item)
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
			.onChange(of: searchingText, perform: { newValue in
				items.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "front CONTAINS[c] %@ OR back CONTAINS[c] %@", newValue, newValue)
			})
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
					NavigationLink {
						SettingsView()
							.navigationTitle("Settings")
					} label: {
						Image(systemName: "gear")
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
				ToolbarItem(placement: .bottomBar) {
					NavigationLink(destination:
									PlayingView(openAddItemView: openAddItemView)
									.withErrorAlert()) {
						Image(systemName: "play.fill")
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
		.preferredColorScheme({
			if schemeMode == 0 {
				return .none
			} else if schemeMode == 1 {
				return .light
			} else if schemeMode == 2 {
				return .dark
			} else {
				return .none
			}
		}())
	}

    private func openAddItemView() {
        showAddItemView = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
			offsets.forEach { idx in
				let item = viewModel.items[idx]
				viewModel.delete(item)
			}
        }
    }
}
