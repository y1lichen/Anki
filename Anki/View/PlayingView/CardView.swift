//
//  CardView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct CardView: View {
    @State private var isFront: Bool = true
	let front: String
	let back: String
    let note: String

    var body: some View {
        VStack {
			if isFront {
				FrontCardView(front: front)
			} else {
				BackCardView(back: back, note: note)
			}
		}
		.frame(width: 300, height: 400)
		.background(Color(UIColor.systemBackground))
		.overlay(RoundedRectangle(cornerRadius: 20.0, style: .circular)
					.stroke(.blue, lineWidth: 8))
		.onTapGesture(perform: {
			isFront.toggle()
		})
    }
}

struct FrontCardView: View {
    let front: String
    var body: some View {
        Text(front)
			.fontWeight(.bold)
			.font(.system(size: 50))
			.minimumScaleFactor(0.4)
    }
}

struct BackCardView: View {
    let back: String
    let note: String
    var body: some View {
        VStack {
			Text(back)
				.fontWeight(.bold)
				.font(.system(size: 50))
				.minimumScaleFactor(0.4)
			Spacer()
				.frame(height: 30)
            Text(note)
				.font(.system(size: 30))
				.minimumScaleFactor(0.2)
				.padding(.horizontal, 10)
        }
		.padding(15)
    }
}
