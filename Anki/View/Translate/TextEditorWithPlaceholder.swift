//
//  TextEditorWithPlaceholder.swift
//  Anki
//
//  Created by 陳奕利 on 2024/4/22.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    let placeholder: String
    let isEditable: Bool
    let showWordCount: Bool
    init(text: Binding<String>, placeholder: String = "", isEditable: Bool = true, showWordCount: Bool = false) {
        _text = text
        self.placeholder = placeholder
        self.isEditable = isEditable
        self.showWordCount = showWordCount
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text(placeholder)
                        .padding(.top, 20)
                        .padding(.leading, 6)
                        .opacity(0.6)
                    Spacer()
                }
            }
            if !showWordCount {
                VStack {
                    TextEditor(text: $text)
                        .padding(.top, 10)
                        .frame(minHeight: 150, maxHeight: 300)
                        .opacity(text.isEmpty ? 0.85 : 1)
                        .disabled(!isEditable)
                    Spacer()
                }
            } else {
                ZStack(alignment: .topTrailing) {
					Text(text.count == 1 || text.count == 0 ? "\(text.count) word": "\(text.count) words")
                        .opacity(0.6)
                    VStack {
                        TextEditor(text: $text)
                            .padding(.top, 10)
                            .frame(minHeight: 150, maxHeight: 300)
                            .opacity(text.isEmpty ? 0.85 : 1)
                            .disabled(!isEditable)
                        Spacer()
                    }
                }
            }
        }
    }
}
