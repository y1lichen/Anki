//
//  ApiManager.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import Foundation

class TranslationService {
	static func getTraslatedResult(prompt: String, completion: @escaping(Result<ResponseDataType, Error>)->Void) {
		let apiKey = UserDefaults.standard.string(forKey: "geminiApiKey")
		guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=\(apiKey ?? "")") else {
			print("Invalid URL")
			return
		}
		
		var request = URLRequest(url: url)
		let json = [
			"contents": [
				"parts": [
					"text": prompt
				]
			]
		]
		let jsonData = try? JSONSerialization.data(withJSONObject: json)
		request.httpMethod = "POST"
		request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData

		
		URLSession.shared.dataTask(with: request) { data, _, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let data = data else {
				completion(.failure(CustomError.noData))
				return
			}
			do {
				let res = try JSONDecoder().decode(ResponseDataType.self, from: data)
				print(res)
				completion(.success(res))
			} catch let error {
				completion(.failure(error))
			}
		}.resume()
		
	}
}
