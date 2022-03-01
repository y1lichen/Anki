//
//  BackButton.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct BackButton: View {
	var presentationMode: Binding<PresentationMode>
	var body: some View {
		Button(action: {
			self.presentationMode.wrappedValue.dismiss()
		}) {
			HStack {
				Image(systemName: "chevron.backward")
					.aspectRatio(contentMode: .fit)
				Text("Back")
					.foregroundColor(.blue)
			}
		}
	}
}
