//
//  ItemModel.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/23.
//

import Foundation
import CoreData

final class ItemModel: ObservableObject {
	@Published var items: [Item]
	
	init() {
		self.items = []
		self.fetchAllItem()
	}
	
	let context = PersistenceController.shared.container.viewContext

	// 0 => front, 1 => back, 2 => time
	func fetchAllItem() {
			do {
				let sortMethod = UserDefaults.standard.integer(forKey: "sortMethod")
				let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
				var sectionSortDescriptor: NSSortDescriptor
				if sortMethod == 0 {
					sectionSortDescriptor = NSSortDescriptor(key: "front", ascending: true)
				} else if sortMethod == 1 {
					sectionSortDescriptor = NSSortDescriptor(key: "back", ascending: true)
				} else {
					sectionSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
				}
				fetchRequest.sortDescriptors = [sectionSortDescriptor]
				items = try context.fetch(fetchRequest) as! [Item]
			} catch {
//				fatalError(error)
			}
		}
}
