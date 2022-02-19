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
	private var items: [Item]
    @State private var shuffeldItems = [Item]()
	
	@State private var itemIndex: Int = 0 {
		didSet {
			selectedItem = shuffeldItems[itemIndex]
			frequency = Int(selectedItem.frequency)
		}
	}
	@State private var selectedItem: Item
	
	@State private var frequency: Int = 0
	
    init(items: [Item], goBackAndAddItem: @escaping () -> Void) {
        itemCount = items.count
        self.goBackAndAddItem = goBackAndAddItem
		self.items = items
		_selectedItem = State(initialValue: items.shuffled()[0])
		_shuffeldItems = State(initialValue: items.shuffled())
		_frequency = State(initialValue: Int(shuffeldItems[itemIndex].frequency))
    }

    var body: some View {
        if itemCount < 3 {
            AltView(goBackAndAddItem: goBackAndAddItem)
        } else {
            VStack {
                Text(selectedItem.front!)
					.font(.system(size: 50))
					.fontWeight(.bold)
					.padding(.top, 10)
				Spacer()
				Button(action: {
					next()
				}) {
					Image(systemName: "arrowtriangle.right.circle.fill")
						.font(.system(size: 60))
				}.padding(.bottom, 40)
				Stepper("Frequency: \(frequency)", value: $frequency, in: 0...5, step: 1)
				.frame(width: 320)
				.padding(.bottom, 30)
			}
        }
    }
	
	private func next() {
		itemIndex = getNextItemIndex()
		shuffeldItems = getWeightedShuffledItemsForNextItem()
	}

	private func getNextItemIndex() -> Int {
		return Int.random(in: 0 ..< shuffeldItems.count)
	}
	
	private func getWeightedShuffledItemsForNextItem() -> [Item] {
		var result = [Item]()
		let baseItems = items.filter {
			$0 != selectedItem
		}
		baseItems.forEach { item in
			result.append(contentsOf: Array(repeating: item, count: Int(item.frequency)))
		}
		return result
    }

    private struct AltView: View {
        let goBackAndAddItem: () -> Void
        var body: some View {
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
        }
    }
}
