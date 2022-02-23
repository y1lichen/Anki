//
//  UserSettings.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/23.
//

import Foundation

final class UserSettings: ObservableObject {
	@Published var sortMethod: Int = UserDefaults.standard.integer(forKey: "sortMethod") {
		didSet {
			UserDefaults.standard.set(self.sortMethod, forKey: "sortMethod")
		}
	}
}
