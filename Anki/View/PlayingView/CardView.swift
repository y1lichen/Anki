//
//  CardView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct CardView: View {
	
	let displayText: String
	let isFront: Bool
	let note: String
	
    var body: some View {
		Text(displayText)
		if !isFront {
			Text(note)
		}
    }
}
