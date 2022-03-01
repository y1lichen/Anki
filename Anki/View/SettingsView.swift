//
//  SettingsView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/3/1.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("schemeMode") private var schemeMode = 0
    var body: some View {
        Group {
            Spacer()
            Form {
                Picker(selection: $schemeMode) {
                    Text("Auto").tag(0)
                    Text("Light").tag(1)
                    Text("Dark").tag(2)
                } label: {
                    Text("Appearance")
                }
            }
        }
    }
}
