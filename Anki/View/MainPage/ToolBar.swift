//
//  ToolBar.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import SwiftUI

struct ToolBar: ToolbarContent {
	var viewModel: ItemViewModel
	
	init(viewModel: ItemViewModel) {
		self.viewModel = viewModel
	}
	
    var body: some ToolbarContent {
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
		ToolbarItem(placement: .bottomBar) { Spacer() }
		ToolbarItem(placement: .bottomBar) {
			NavigationLink(destination:
				PlayingView(openAddItemView: viewModel.openAddItemView)
					.withErrorAlert()) {
				Image(systemName: "play.fill")
			}
		}
		ToolbarItem(placement: .bottomBar) { Spacer().frame(width: 5) }
		ToolbarItem(placement: .bottomBar) {
			NavigationLink(destination: TranslateView().withErrorAlert()) {
				Image(systemName: "character.phonetic")
			}
		}
		ToolbarItem(placement: .bottomBar) { Spacer() }
    }
}
