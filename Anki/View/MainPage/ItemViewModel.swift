//
//  ItemModel.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/23.
//

import CoreData
import Foundation

class ItemViewModel: ObservableObject {
	@Published var items: [Item]
	let context = PersistenceController.shared.container.viewContext
	
	var front: String = ""
	var back: String = ""
	var note: String = ""
	@Published var frequency: Float = 3.0
	
	init() {
		items = []
		fetchItems()
		sortItems()
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
	
	func checkValid() -> Bool {
		if front.isEmpty || back.isEmpty {
			return false
		}
		return true
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
