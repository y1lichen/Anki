//
//  ViewState.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/23.
//

import Foundation

enum ViewState: Equatable {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case(.idle, .idle):
            return true
		case(.loading, .loading):
			return true
		case(.success, .success):
			return true
		case(.error(let lhsType), .error(let rhsType)):
			return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }

    case idle
    case loading
    case success
    case error(Error)
}
