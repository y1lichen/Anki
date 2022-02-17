//
//  EditItemView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/17.
//

import SwiftUI

struct EditItemView: View {
    private var item: Item
    @State private var newFront: String
    @State private var newBack: String
    @State private var newFrequency: Float

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(item: Item, updateItem: @escaping () -> Void) {
        self.item = item
        self.updateItem = updateItem
        _newFront = State(initialValue: item.front!)
        _newBack = State(initialValue: item.back!)
        _newFrequency = State(initialValue: Float(item.frequency))
    }

    private var updateItem: () -> Void

    var body: some View {
        Form {
            Section(header: Text("Card")) {
                TextField("Front", text: $newFront)
                TextField("Back", text: $newBack)
            }

            Section(header: Text("Frequency: \(Int(newFrequency))")) {
                Slider(value: $newFrequency, in: 0 ... 5, step: 1,
                       label: { Text("Frequency of notification") },
                       minimumValueLabel: { Text("0") },
                       maximumValueLabel: { Text("5") }
                )
            }
        }
        .navigationTitle(newFront)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: saveButton)
    }

    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .aspectRatio(contentMode: .fit)
                Text("Back")
            }
        }
    }

    var saveButton: some View {
        Button(action: {
        }) {
            Text("Save")
        }
    }
}
