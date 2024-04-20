//
//  CoreDataManager.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/20.
//

import Foundation
import CoreData

class CoreDataManager {
	static let shared = CoreDataManager()
	
	let context = PersistenceController.shared.container.viewContext
	
	func selectItemByPattern(_ pattern: String) -> [Item] {
		do {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
			fetchRequest.predicate = NSPredicate(format: "front CONTAINS[c] %@ OR back CONTAINS[c] %@", pattern, pattern)
			return try context.fetch(fetchRequest) as! [Item]
		} catch {
			return []
		}
	}
	
	func getAllItem() -> [Item] {
		do {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
			return try context.fetch(fetchRequest) as! [Item]
		} catch {
			//				fatalError(error)
			return []
		}
	}
	
	func getItemById(id: NSManagedObjectID) -> Item? {
		do {
			return try context.existingObject(with: id) as? Item
		} catch {
			return nil
		}
	}

	func deleteItem(_ item: Item) {
		context.delete(item)
		save()
	}
	
	func save() {
		do {
			try context.save()
		} catch {
			context.rollback()
			print(error.localizedDescription)
		}
	}
}
