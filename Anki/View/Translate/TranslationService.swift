//
//  ApiManager.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import AVFoundation
import Foundation
import NaturalLanguage

class TranslationService {
	static let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
	
    static func getTraslatedResult(prompt: String, completion: @escaping (Result<ResponseDataType, Error>) -> Void) {
        let apiKey = UserDefaults.standard.string(forKey: "geminiApiKey")
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=\(apiKey ?? "")") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        let json = [
            "contents": [
                "parts": [
                    "text": prompt,
                ],
            ],
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

    private static func getLanguageOfInput(_ input: String) -> NLLanguage? {
        let languageRecognizer = NLLanguageRecognizer()
        languageRecognizer.processString(input)
        return languageRecognizer.dominantLanguage
    }

    static func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        if let language = getLanguageOfInput(text) {
            utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue)
            synthesizer.speak(utterance)
        }
    }
	
	static func stopSpeakText(_ text: String) {
		synthesizer.stopSpeaking(at: .immediate)
	}
}
