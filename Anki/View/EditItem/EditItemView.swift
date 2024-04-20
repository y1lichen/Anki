//
//  EditItemView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/17.
//

import SwiftUI

struct EditItemView: View {
    private var item: Item

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var viewModel = ItemViewModel()
	
    init(item: Item) {
        self.item = item
    }

    var body: some View {
        Form {
            Section(header: Text("Card")) {
				TextField("Front", text: $viewModel.front)
				TextField("Back", text: $viewModel.back)
            }

			Section(header: Text("Note")) {
				TextEditor(text: $viewModel.note)
					.frame(height: 100)
			}
			
			Section(header: Text("Frequency: \(Int(viewModel.frequency))")) {
				Slider(value: $viewModel.frequency, in: 0 ... 5, step: 1,
                       label: { Text("Frequency of notification") },
                       minimumValueLabel: { Text("0") },
                       maximumValueLabel: { Text("5") }
                )
            }
        }
		.navigationTitle(viewModel.front)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(presentationMode: presentationMode), trailing: saveButton)
		.onAppear {
			// 不能在init()裡做
			// 否則報錯 Accessing StateObject's object without being installed on a View.
			viewModel.front = item.front ?? ""
			viewModel.back = item.back ?? ""
			viewModel.note = item.note ?? ""
			viewModel.frequency = Float(item.frequency)
		}
	}

    var saveButton: some View {
        Button(action: {
			viewModel.updateItem(item)
			self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save")
        }
    }
}
