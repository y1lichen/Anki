//
//  QuizView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct QuizView: View {
    var items: [Item]
	
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }

    private func getWeightedItems() -> [Item] {
        var result: [Item] = []
        items.forEach { item in
            let frequency = item.frequency
            result.append(contentsOf: Array(repeating: item, count: Int(frequency)))
        }
        return result.shuffled()
    }
}
