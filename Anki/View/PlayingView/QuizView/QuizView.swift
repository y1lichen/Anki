//
//  QuizView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct QuizView: View {
	let context = PersistenceController.shared.container.viewContext

    let goBackAndAddItem: () -> Void
    let itemCount: Int
    private var items: [Item]

    @State private var shuffeldItems = [Item]()

    @State private var itemIndex: Int = 0 {
        didSet {
            selectedItem = shuffeldItems[itemIndex]
            frequency = Int(selectedItem.frequency)
            options = getOptions()
        }
    }

	private var itemsIsEmpty: Bool = false

    @State private var selectedItem: Item!
	@State private var frequency: Int = 0

    @State private var isWrong: Bool = false
	@State private var options = [String]()

    init(items: [Item], goBackAndAddItem: @escaping () -> Void) {
        itemCount = items.count
        self.goBackAndAddItem = goBackAndAddItem
        self.items = items
		if items.isEmpty { itemsIsEmpty = true }
		_selectedItem = State(initialValue: itemsIsEmpty ? nil : items.shuffled()[0])
		_shuffeldItems = State(initialValue: items.shuffled())
		_frequency = State(initialValue: Int(itemsIsEmpty ? 0 : shuffeldItems[itemIndex].frequency))
		_options = State(initialValue: itemsIsEmpty ? [] : getOptions())
    }

    var body: some View {
        if itemCount < 3 {
            AltView(goBackAndAddItem: goBackAndAddItem)
        } else {
            VStack {
                Spacer()
                Text(selectedItem.front!)
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Spacer()
                    .frame(height: 60)
                ForEach(options, id: \.self) { option in
                    OptionButton(option: option, item: selectedItem.back!, next: next, isWrong: $isWrong)
                        .padding(.bottom, 15)
                }
                Spacer()
                    .frame(height: 45)
                Button(action: {
                    next()
                }) {
                    Image(systemName: "arrowtriangle.right.circle.fill")
                        .font(.system(size: 60))
                }.padding()
                Spacer()
                Stepper("Frequency: \(frequency)", value: $frequency, in: 0 ... 5, step: 1)
                    .frame(width: 320)
                    .padding(.bottom, 30)
					.onChange(of: frequency) { newValue in
						selectedItem.frequency = Int64(newValue)
						try? context.save()
					}
            }
        }
    }

    private func getOptions() -> [String] {
        var options: [String] = [selectedItem.back!]
        var baseItems = items.filter { $0 != selectedItem }
        for _ in 0 ... 1 {
            let optionIndex = Int.random(in: 0 ..< baseItems.count)
            options.append(baseItems[optionIndex].back!)
            baseItems = baseItems.filter { $0 != baseItems[optionIndex] }
        }
        return options.shuffled()
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
        let baseItems = items.filter { $0 != selectedItem }
        baseItems.forEach { item in
            result.append(contentsOf: Array(repeating: item, count: Int(item.frequency)))
        }
        return result
    }

    struct AltView: View {
        let goBackAndAddItem: () -> Void
        var body: some View {
            VStack {
                Text("In order to take quizzes, you must create at least 3 items.")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(10)
                Button { goBackAndAddItem() } label: {
                    Text("Click to create.")
                }
            }
        }
    }
}

private struct OptionButton: View {
    let option: String
    let item: String
    let next: () -> Void
    @Binding var isWrong: Bool
	@State private var currentColorIsBlue: Bool = true

	private func changeColorAnimation() {
		currentColorIsBlue = false
		withAnimation(Animation.linear(duration: 0.2).delay(0.2)) {
		   currentColorIsBlue = true
		}
	}

	private func errorVibration() {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.error)
	}

    private func handleOnClick() {
        if option != item {
            isWrong = true
			errorVibration()
			changeColorAnimation()
        } else {
            next()
        }
    }

    var body: some View {
        Button(action: { handleOnClick() }) {
            ZStack {
                Text(option)
                    .font(.title)
                    .fontWeight(.bold)
					.foregroundColor(.blue)
                    .frame(width: 160, height: 68)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
							.stroke(.blue, lineWidth: 5)
                    )
					.opacity(currentColorIsBlue ? 1 : 0)
				Text(option)
					.font(.title)
					.fontWeight(.bold)
					.foregroundColor(.red)
					.frame(width: 160, height: 68)
					.overlay(
						RoundedRectangle(cornerRadius: 40)
							.stroke(.red, lineWidth: 5)
					)
					.opacity(currentColorIsBlue ? 0 : 1)
            }
        }
    }
}
