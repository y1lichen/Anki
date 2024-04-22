//
//  SettingsView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/3/1.
//

import SwiftUI

struct SettingsView: View {
	
	@StateObject var settingViewModel = SettingViewModel.shared
	
    var body: some View {
        Form {
			Section("Flashcards") {
				Picker(selection: $settingViewModel.settings.schemeMode) {
					Text("Auto").tag(0)
					Text("Light").tag(1)
					Text("Dark").tag(2)
				} label: {
					Text("Appearance")
				}
				Picker(selection: $settingViewModel.settings.sortMethod) {
					Text("Front").tag(0)
					Text("Back").tag(1)
					Text("Added time").tag(2)
				} label: {
					Text("Sort by")
				}
				
				Button(action: {
					settingViewModel.setIsExport(true)
				}) {
					Text("Export CSV File")
				}
			}
			
			Section("Translation") {
				Picker(selection: $settingViewModel.settings.translateTo) {
					Text("English").tag(TranslateTo.english.rawValue)
					Text("繁體中文").tag(TranslateTo.tradChinese.rawValue)
					Text("簡體中文").tag(TranslateTo.simChinese.rawValue)
					Text("日本語").tag(TranslateTo.japanese.rawValue)
				} label: {
					Text("Translate to")
				}
				TextField("Gemini API key", text: $settingViewModel.settings.geminiApiKey)
			}
		}
		.alert("Error!", isPresented: $settingViewModel.showAlert, actions: {
			Button("Ok", role: .none, action: {
				settingViewModel.toggleShowAlert()
			})
		}, message:{
			Text("Unable to export CSV file.")
		})
		.fileExporter(isPresented: $settingViewModel.isExport,
					  document: settingViewModel.createDocument(),
					  contentType: .commaSeparatedText,
					  defaultFilename: settingViewModel.getExportDocumentFileName())
		{ result in
			if case .failure = result {
				settingViewModel.toggleShowAlert()
			}
		}
    }
}
