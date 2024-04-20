//
//  AddItemView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/17.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ItemViewModel()

    @EnvironmentObject var errorHandling: ErrorHandling
    @State private var showAlert: Bool = false

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("New Item")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button("Close", action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }.listRowBackground(Color(UIColor.systemGroupedBackground))

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
        .alert("Unable to create new item!", isPresented: $showAlert, actions: {
            Button("Ok") {}
        }, message: {
            Text("The front and the back of the item is required.")
        })
		Spacer()
		Button("Add") {
			addItem()
			presentationMode.wrappedValue.dismiss()
		}
    }

    private func addItem() {
		if viewModel.checkValid() {
			viewModel.saveNewItem()
        } else {
            showAlert = true
        }
    }
}
