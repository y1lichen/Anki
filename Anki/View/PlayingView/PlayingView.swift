//
//  PlayingView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/17.
//

import CoreData
import SwiftUI

struct PlayingView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let openAddItemView: () -> Void

    init(openAddItemView: @escaping () -> Void) {
        self.openAddItemView = openAddItemView
    }

    @State private var isStudyView: Bool = true

    var body: some View {
        VStack {
            if isStudyView {
                StudyView(goBackAndAddItem: goBackAndAddItem)
            } else {
				QuizView(goBackAndAddItem: goBackAndAddItem)
            }
        }
        .background(NavigationConfigurator {
            navigationConfigurator in
            navigationConfigurator.hidesBarsOnSwipe = true
        })
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(presentationMode: presentationMode)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if !isStudyView {
                    Button(action: {
                        isStudyView = true
                    }) {
                        Label("Study", systemImage: "book")
                    }
                } else {
                    Button(action: {
                        isStudyView = false
                    }) {
                        Label("Quiz", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .statusBar(hidden: true)
    }

    private func goBackAndAddItem() {
        presentationMode.wrappedValue.dismiss()
        openAddItemView()
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = controller.navigationController {
                self.configure(navigationController)
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController,
                                context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
    }
}
