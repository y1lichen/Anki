//
//  AddItemView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/17.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject var errorHandling: ErrorHandling
    @State private var showAlert: Bool = false

    @State private var front: String = ""
    @State private var back: String = ""
    @State private var frequency: Float = 3.0

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
                TextField("Front", text: $front)
                TextField("Back", text: $back)
            }
			
            Section(header: Text("Frequency: \(Int(frequency))")) {
                Slider(value: $frequency, in: 0 ... 5, step: 1,
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

    private func checkValid() -> Bool {
        if front.isEmpty || back.isEmpty {
            return false
        }
        return true
    }

    private func addItem() {
        if checkValid() {
            let newItem = Item(context: viewContext)
            let uuid = UUID()
            newItem.id = uuid
            newItem.front = front
            newItem.back = back
            newItem.frequency = Int64(frequency)
			newItem.timestamp = Date()
            do {
                try viewContext.save()
            } catch {
                errorHandling.handleError(error: error)
            }
        } else {
            showAlert = true
        }
    }
}
