//
//  PlayingView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/17.
//

import SwiftUI

struct PlayingView: View {
    @State private var showTabBar: Bool = true

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
        }
        .background(NavigationConfigurator {
            navigationConfigurator in
            navigationConfigurator.hidesBarsOnTap = true
        })
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
				BackButton(presentationMode: presentationMode)
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button(action: {}) {
                    Label("Study", systemImage: "book")
                }
                Spacer()
                Button(action: {}) {
                    Label("Quiz", systemImage: "square.and.pencil")
                }
                Spacer()
            }
        }
        .statusBar(hidden: true)
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
