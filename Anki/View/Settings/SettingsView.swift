//
//  SettingsView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/3/1.
//

import SwiftUI

struct SettingsView: View {
	
	@State private var isExport: Bool = false
	@State private var showAlert: Bool = false
	
	@AppStorage("sortMethod") private var sortMethod = 0
    @AppStorage("schemeMode") private var schemeMode = 0
	
	@StateObject var viewModel = ItemViewModel()

	
	let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "y_MM_dd_HH:mm:ss"
		return formatter
	}()
	
	private func createDocument() -> ExportDocument {
		var document: ExportDocument
		var data: String = "Front,Back,Note,timetamp\n"
		for item in viewModel.items {
			data += "\(item.front!),\(item.back!),\(item.note!),\(item.timestamp!.description)\n"
		}
		document = ExportDocument(documentData: data)
		return document
	}
	
	private func getExportDocumentFileName() -> String {
		var result: String = "anki"
		result += dateFormatter.string(from: Date())
		return result
	}
	
    var body: some View {
        Form {
            Picker(selection: $schemeMode) {
                Text("Auto").tag(0)
                Text("Light").tag(1)
                Text("Dark").tag(2)
            } label: {
                Text("Appearance")
            }
			Picker(selection: $sortMethod) {
				Text("Front").tag(0)
				Text("Back").tag(1)
				Text("Added time").tag(2)
			} label: {
				Text("Sort by")
			}

            Button(action: {
				isExport = true
			}) {
                Text("Export CSV File")
            }
		}
		.alert("Error!", isPresented: $showAlert, actions: {
			Button("Ok", role: .none, action: {})
		}, message:{
			Text("Unable to export CSV file.")
		})
		.fileExporter(isPresented: $isExport,
					  document: createDocument(),
					  contentType: .commaSeparatedText,
					  defaultFilename: getExportDocumentFileName())
		{ result in
			if case .failure = result {
				showAlert = true
			}
		}
    }
}
