//
//  SettingViewModel.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/21.
//

import Foundation
import SwiftUI

class SettingViewModel: ObservableObject {
	var viewModel = ItemViewModel()
	
	static let shared = SettingViewModel()
	
	@Published var isExport: Bool = false
	@Published var showAlert: Bool = false
	
	@Published var settings = SettingModel()
	
	let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "y_MM_dd_HH:mm:ss"
		return formatter
	}()
	
	func toggleShowAlert() {
		showAlert.toggle()
	}
	
	func setIsExport(_ value: Bool) {
		isExport = value
	}
	
	func createDocument() -> ExportDocument {
		var document: ExportDocument
		var data: String = "Front,Back,Note,timetamp\n"
		for item in viewModel.items {
			data += "\(item.front!),\(item.back!),\(item.note!),\(item.timestamp!.description)\n"
		}
		document = ExportDocument(documentData: data)
		return document
	}
	
	func getExportDocumentFileName() -> String {
		var result: String = "anki"
		result += dateFormatter.string(from: Date())
		return result
	}
}
