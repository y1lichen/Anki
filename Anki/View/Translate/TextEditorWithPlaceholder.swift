//
//  TextEditorWithPlaceholder.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    @ObservedObject var viewModel: TranslateViewModel
    
    let placeholder: String
    @FocusState private var isFocused: Bool

    init(viewModel: TranslateViewModel, text: Binding<String>, placeholder: String = "") {
        self.viewModel = viewModel
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack(alignment: .leading) {
			if  viewModel.text.isEmpty {
                VStack {
                    Text(placeholder)
                        .padding(.top, 20)
                        .padding(.leading, 6)
                        .opacity(0.6)
                    Spacer()
                }
            }

            ZStack(alignment: .topTrailing) {
                Text(viewModel.text.count == 1 || viewModel.text.count == 0 ? "\(viewModel.text.count) word" : "\(viewModel.text.count) words")
                    .opacity(0.6)
                VStack {
					TextEditor(text: $viewModel.text)
                        .onChange(of: viewModel.text) { _ in
                            if viewModel.text.last?.isNewline == .some(true) {
								// 移除最後一個\n
								viewModel.text.removeLast()
								if viewModel.text.isEmpty {
									return
								}
                                isFocused = false
								viewModel.fetchData()
                            }
                        }
                        .focused($isFocused)
                        .submitLabel(.done)
                        .padding(.top, 10)
                        .frame(minHeight: 150, maxHeight: 300)
                        .opacity(viewModel.text.isEmpty ? 0.85 : 1)
                    Spacer()
                }
            }
        }
    }
}
