//
//  ItemModel.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/23.
//

import CoreData
import Foundation

final class ItemModel {
    var items: [Item]
	let context = PersistenceController.shared.container.viewContext
    
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
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            items = try context.fetch(fetchRequest) as! [Item]
        } catch {
            //				fatalError(error)
        }
    }
}
