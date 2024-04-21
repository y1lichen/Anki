//
//  ItemModel.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/23.
//

import CoreData
import Foundation
import SwiftUI

class ItemViewModel: ObservableObject {
    @Published var items: [Item]
    let context = PersistenceController.shared.container.viewContext
	
	@AppStorage("schemeMode") var schemeMode = 0

    @Published var navigationTitle = "Anki"
    @Published var searchingText = "" {
        didSet {
            if searchingText.isEmpty {
                fetchItems()
            } else {
                fetchItemsContainPattern(searchingText)
            }
        }
    }

    @Published var showAddItemView = false

    @Published var front: String = ""
    @Published var back: String = ""
    @Published var note: String = ""
    @Published var frequency: Float = 3.0

    init() {
        items = []
        fetchItems()
        sortItems()
    }
	
	func getSchemeMode() -> ColorScheme? {
		if schemeMode == 0 {
			return .none
		} else if schemeMode == 1 {
			return .light
		} else if schemeMode == 2 {
			return .dark
		} else {
			return .none
		}
	}
    func openAddItemView() {
        showAddItemView = true
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { idx in
                let item = items[idx]
                delete(item)
            }
        }
    }

    // 0 => front, 1 => back, 2 => time
    func sortItems() {
        let sortMethod = UserDefaults.standard.integer(forKey: "sortMethod")
        if sortMethod == 0 {
            items = items.sorted(by: { $0.front! < $1.front! })
        } else if sortMethod == 1 {
            items = items.sorted(by: { $0.back! < $1.back! })
        } else if sortMethod == 2 {
            items = items.sorted(by: { $0.timestamp! < $1.timestamp! })
        }
    }

    func fetchItems() {
        items = CoreDataManager.shared.getAllItem()
    }

    func fetchItemsContainPattern(_ pattern: String) {
        items = CoreDataManager.shared.selectItemByPattern(pattern)
    }

    func checkValid() -> Bool {
        if front.isEmpty || back.isEmpty {
            return false
        }
        return true
    }

    func updateItem(_ item: Item) {
        let existingItem = CoreDataManager.shared.getItemById(id: item.objectID)
        if let existingItem = existingItem {
            existingItem.front = front
            existingItem.back = back
            existingItem.note = note
            existingItem.frequency = Int64(frequency)
            CoreDataManager.shared.save()
        }
    }

    func saveNewItem() {
        let newItem = Item(context: CoreDataManager.shared.context)
        let uuid = UUID()
        newItem.id = uuid
        newItem.front = front
        newItem.back = back
        newItem.note = note
        newItem.frequency = Int64(frequency)
        newItem.timestamp = Date()
        CoreDataManager.shared.save()
    }

    func delete(_ item: Item) {
        let existingItem = CoreDataManager.shared.getItemById(id: item.objectID)
        if let existingItem = existingItem {
            CoreDataManager.shared.deleteItem(existingItem)
        }
    }
}
