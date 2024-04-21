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
	@AppStorage("geminiApiKey") var geminiApiKey = "AIzaSyCN_Ipm0E2nVertIp9-qpgRv8RTEBhvpU4"
}
