//
//  TranslateViewModel.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import Combine
import Foundation


class TranslateViewModel: ObservableObject {
    @Published var text = ""
    @Published var result = ""
		
    @Published var state: ViewState = .idle

    private var cancellable: AnyCancellable?
	
	private func getPrompt() -> String {
		let translateTo = UserDefaults.standard.string(forKey: "translateTo")
		return "請用\(translateTo ?? "英文")翻譯並解釋「\(text)」，並說明使用情境。"
	}

    func fetchData() {
        state = .loading
        TranslationService.getTraslatedResult(prompt: getPrompt()) { result in
            switch result {
            case let .success(data):
				// 要在main thread裡執行
                DispatchQueue.main.async {
                    self.result = data.candidates.first?.content.parts.first?.text ?? ""
					self.state = .success
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.result = ""
					self.state = .error(error)
                }
            }
        }
    }
	
	func startTTSText() {
		TranslationService.speakText(text)
	}
}
