//
//  SettingsView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/3/1.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("sortMethod") private var sortMethod = 0
	
    @AppStorage("schemeMode") private var schemeMode = 0
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

            Button(action: {}) {
                Text("Export CSV File")
            }
		}
    }
}

