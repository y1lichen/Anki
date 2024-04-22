//
//  SettingModel.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/21.
//

import Foundation
import SwiftUI

struct SettingModel {
	
	@AppStorage("sortMethod") var sortMethod = 0
	@AppStorage("schemeMode") var schemeMode = 0
	@AppStorage("translateTo") var translateTo = 0
	@AppStorage("geminiApiKey") var geminiApiKey = ""
}
