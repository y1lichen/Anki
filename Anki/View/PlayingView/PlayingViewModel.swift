//
//  PlayingViewModel.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/20.
//
import CoreData
import Foundation

class PlayingViewModel: ObservableObject {
    @Published var items: [Item] = []
    let context = PersistenceController.shared.container.viewContext

    var itemsIsEmpty = true
    var shuffledItems: [Item] = []
    var options = [String]()
	
	var itemIndex: Int = 0

    @Published var selectedItem: Item!

    @Published var frequency: Int = 0 {
        didSet {
            updateItemFrequency(selectedItem!)
        }
    }

    init() {
        fetchItems()
		itemsIsEmpty = items.isEmpty
		shuffledItems = getWeightedItems()
		itemIndex = getNextItemIndex()
		//
		selectedItem = shuffledItems[itemIndex]
		frequency = Int(itemsIsEmpty ? 0 : shuffledItems[itemIndex].frequency)
        options = getOptions()
		
    }

    func updateItemFrequency(_ item: Item) {
        let existingItem = CoreDataManager.shared.getItemById(id: item.objectID)
        if let existingItem = existingItem {
            existingItem.frequency = Int64(frequency)
            CoreDataManager.shared.save()
        }
    }
	
    func fetchItems() {
        items = CoreDataManager.shared.getAllItem()
        itemsIsEmpty = items.count == 0
    }

    func getNextItemIndex() -> Int {
        return Int.random(in: 0 ..< shuffledItems.count)
    }

    func next() {
        itemIndex = getNextItemIndex()
		shuffledItems = shuffledItems.shuffled()
		selectedItem = shuffledItems[itemIndex]
		frequency = Int(selectedItem!.frequency)
		options = getOptions()
    }

    func getOptions() -> [String] {
        var options: [String] = [selectedItem?.back! ?? ""]
        var baseItems = items.filter { $0 != selectedItem }
        for _ in 0 ... 1 {
            let optionIndex = Int.random(in: 0 ..< baseItems.count)
            options.append(baseItems[optionIndex].back!)
            baseItems = baseItems.filter { $0 != baseItems[optionIndex] }
        }
        return options.shuffled()
    }

    func getWeightedItems() -> [Item] {
        var result = [Item]()
        items.forEach { item in
            result.append(contentsOf: Array(repeating: item, count: Int(item.frequency)))
        }
		result = result.shuffled()
        return result
    }
}
