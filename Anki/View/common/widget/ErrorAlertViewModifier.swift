//
//  ErrorAlert.swift
//  RandomReminder
//
//  Created by 陳奕利 on 2022/2/7.
//

import Foundation
import SwiftUI

struct ErrorAlert: Identifiable {
	var id = UUID()
	var message: String
	var dismissAction: (() -> Void)?
}

class ErrorHandling: ObservableObject {
	@Published var currentAlert: ErrorAlert?
	func handleError(error: Error) {
		currentAlert = ErrorAlert(message: error.localizedDescription)
	}
}

struct HandleErrorByShowingAlertViewModifier: ViewModifier {
	@StateObject var errorHandling = ErrorHandling()
	
	func body(content: Content) -> some View {
		content.environmentObject(errorHandling)
			.background(EmptyView()
							.alert(item: $errorHandling.currentAlert, content: { currentAlert in
				Alert(title: Text("Error!"), message: Text(currentAlert.message), dismissButton: .default(Text("Ok")) {
					currentAlert.dismissAction?()
				})
			})
		)
	}
}

extension View {
	func withErrorAlert() -> some View {
		modifier(HandleErrorByShowingAlertViewModifier())
	}
}
