//
//  TranslateViewModel.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import Combine
import Foundation

enum ViewState {
    case idle
    case loading
    case success
    case error(Error)
}

class TranslateViewModel: ObservableObject {
    @Published var text = ""
    @Published var result = ""

    var state: ViewState = .idle

    private var cancellable: AnyCancellable?

    func fetchData() {
        state = .loading
        TranslationService.getTraslatedResult(text: text) { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.result = data.candidates.first?.content.parts.first?.text ?? ""
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.result = ""
                }
                self.state = .error(error)
            }
        }
    }
}
