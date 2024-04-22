//
//  ResponseDataType.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import Foundation

struct ResponseDataType: Codable {
	let candidates: [Candidate]
	struct Candidate: Codable {
		let content: Content
		let finishReason: String
		let index: Int
		let safetyRatings: [SafetyRating]
		struct SafetyRating: Codable {
			let category: String
			let probability: String
		}
		struct Content: Codable {
			struct Text: Codable {
				let text: String
			}
			let parts: [Text]
			let role: String
		}
	}
}
