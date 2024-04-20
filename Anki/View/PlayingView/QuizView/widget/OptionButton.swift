//
//  OptionButton.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/21.
//

import Foundation
import SwiftUI

struct OptionButton: View {
	// 觀察ParentView的StateObject，否則每一個button都會有自己的stateobject
	@ObservedObject var viewModel: PlayingViewModel
	let option: String
	@Binding var isWrong: Bool
	@State private var currentColorIsBlue: Bool = true

	private func changeColorAnimation() {
		currentColorIsBlue = false
		withAnimation(Animation.linear(duration: 0.2).delay(0.2)) {
			currentColorIsBlue = true
		}
	}

	private func errorVibration() {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.error)
	}

	private func handleOnClick() {
		if option != viewModel.selectedItem!.back {
			isWrong = true
			errorVibration()
			changeColorAnimation()
		} else {
			viewModel.next()
		}
	}

	var body: some View {
		Button(action: { handleOnClick() }) {
			ZStack {
				Text(option)
					.font(.title)
					.fontWeight(.bold)
					.foregroundColor(.blue)
					.frame(width: 160, height: 68)
					.overlay(
						RoundedRectangle(cornerRadius: 40)
							.stroke(.blue, lineWidth: 5)
					)
					.opacity(currentColorIsBlue ? 1 : 0)
				Text(option)
					.font(.title)
					.fontWeight(.bold)
					.foregroundColor(.red)
					.frame(width: 160, height: 68)
					.overlay(
						RoundedRectangle(cornerRadius: 40)
							.stroke(.red, lineWidth: 5)
					)
					.opacity(currentColorIsBlue ? 0 : 1)
			}
		}
	}
}
