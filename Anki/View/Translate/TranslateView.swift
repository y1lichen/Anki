//
//  Translate.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import SwiftUI

struct TranslateView: View {
	@StateObject var viewModel = TranslateViewModel()
    var body: some View {
        VStack {
            Form {
                Section {
					TextEditorWithPlaceholder(text: $viewModel.text, placeholder: "Input...", showWordCount: true)
						.autocorrectionDisabled()
                        .frame(height: 180)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                }
                Section {
					TextEditorWithPlaceholder(text: $viewModel.result, placeholder: "", isEditable: false)
                        .frame(height: 180)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                }
            }
        }
    }
}
