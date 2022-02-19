//
//  StudyView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct StudyView: View {
	
	let items: [Item]
	let goBackAndAddItem: () -> Void
	
    var body: some View {
		if items.count == 0 {
			Text("No item found.")
				.fontWeight(.bold)
			Button {
				goBackAndAddItem()
			} label: {
				Text("Click to create.")
			}
		} else {
			Text("Study")
		}
    }
}
