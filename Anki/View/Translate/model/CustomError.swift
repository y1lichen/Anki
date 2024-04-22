//
//  CustomError.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import Foundation

public enum CustomError {
	case noData, noConnection
}

extension CustomError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .noData:
			return "no data"
		case .noConnection:
			return "no connection"
		}
	}
}
