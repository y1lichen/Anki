//
//  QuizView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct QuizView: View {
    let goBackAndAddItem: () -> Void
    init(goBackAndAddItem: @escaping () -> Void) {
        self.goBackAndAddItem = goBackAndAddItem
    }

    @StateObject var viewModel = PlayingViewModel()
    @State private var isWrong: Bool = false

    var body: some View {
        if viewModel.items.count < 3 {
            AltView(goBackAndAddItem: goBackAndAddItem)
        } else {
            VStack {
                Spacer()
                Text(viewModel.selectedItem?.front! ?? "")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Spacer()
                    .frame(height: 60)
                ForEach(viewModel.options, id: \.self) { option in
                    OptionButton(viewModel: viewModel, option: option, isWrong: $isWrong)
                        .padding(.bottom, 15)
                }
                Spacer()
                    .frame(height: 45)
                Button(action: {
                    viewModel.next()
                }) {
                    Image(systemName: "arrowtriangle.right.circle.fill")
                        .font(.system(size: 60))
                }.padding()
                Spacer()
                Stepper("Frequency: \(viewModel.frequency)", value: $viewModel.frequency, in: 0 ... 5, step: 1)
                    .frame(width: 320)
                    .padding(.bottom, 30)
            }
        }
    }
}
