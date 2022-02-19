//
//  QuizView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct QuizView: View {
    let goBackAndAddItem: () -> Void
	let itemCount: Int
    var shuffeldItems = [Item]()

    @State private var itemIndex: Int! = nil

    init(items: [Item], goBackAndAddItem: @escaping () -> Void) {
		self.itemCount = items.count
        self.goBackAndAddItem = goBackAndAddItem
		self.shuffeldItems = getWeightedItems(items: items)
        _itemIndex = State(initialValue: Int.random(in: 0 ... shuffeldItems.count))
    }

    var body: some View {
        if itemCount < 3 {
            VStack {
                Text("In order to take quizzes, you must create at least 3 items.")
					.fontWeight(.bold)
					.multilineTextAlignment(.center)
					.padding(10)
                Button {
                    goBackAndAddItem()
                } label: {
                    Text("Click to create.")
                }
            }
        } else {
            Text(shuffeldItems[itemIndex].front!)
        }
    }

    private func getWeightedItems(items: [Item]) -> [Item] {
        var result: [Item] = []
        items.forEach { item in
            let frequency = item.frequency
            result.append(contentsOf: Array(repeating: item, count: Int(frequency)))
        }
        return result.shuffled()
    }
}
