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

	@StateObject var viewModel = ItemViewModel()
	@StateObject var settingViewModel = SettingViewModel.shared
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
				.onDelete(perform: viewModel.deleteItems)
            }
			.searchable(text: $viewModel.searchingText)
			.onChange(of: viewModel.searchingText, perform: { newValue in
				if newValue.isEmpty {
					viewModel.fetchItems()
				} else {
					viewModel.fetchItemsContainPattern(newValue)
				}
			})
			.onChange(of: settingViewModel.settings.sortMethod, perform: { _ in
				viewModel.sortItems()
			})
			.navigationTitle(viewModel.navigationTitle)
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
					Button(action: viewModel.openAddItemView) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
				ToolbarItem(placement: .bottomBar) {
					NavigationLink(destination:
									PlayingView(openAddItemView: viewModel.openAddItemView)
									.withErrorAlert()) {
						Image(systemName: "play.fill")
					}
				}
			}
			.onAppear(perform: {
				viewModel.navigationTitle = "Anki"
            })
            .onDisappear(perform: {
				viewModel.navigationTitle = "Menu"
            })
        }
		.sheet(isPresented: $viewModel.showAddItemView) {
            AddItemView().withErrorAlert()
        }
		.preferredColorScheme({
			viewModel.getSchemeMode()
		}())
	}
}
