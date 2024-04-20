//
//  AltView.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/21.
//

import Foundation
import SwiftUI

// 資料太少而不能測試時的畫面
struct AltView: View {
	let goBackAndAddItem: () -> Void
	var body: some View {
		VStack {
			Text("In order to take quizzes, you must create at least 3 items.")
				.fontWeight(.bold)
				.multilineTextAlignment(.center)
				.padding(10)
			Button { goBackAndAddItem() } label: {
				Text("Click to create.")
			}
		}
	}
}
