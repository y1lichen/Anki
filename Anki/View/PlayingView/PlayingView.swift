//
//  PlayingView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/17.
//

import CoreData
import SwiftUI

struct PlayingView: View {
    @ObservedObject var userSettings = UserSettings()
	@StateObject var itemModel: ItemModel = ItemModel()

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
    let openAddItemView: () -> Void

    init(openAddItemView: @escaping () -> Void) {
        self.openAddItemView = openAddItemView
    }

    @State private var isStudyView: Bool = true

    var body: some View {
        VStack {
            if isStudyView {
				StudyView(items: itemModel.items, goBackAndAddItem: goBackAndAddItem)
			} else {
				QuizView(items: itemModel.items, goBackAndAddItem: goBackAndAddItem)
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

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if isStudyView {
                    Menu {
						Picker("Sort by:", selection: $userSettings.sortMethod) {
                            Text("Front").tag(0)
                            Text("Back").tag(1)
                            Text("Added time").tag(2)
						}
						.onChange(of: userSettings.sortMethod) { newValue in
							userSettings.sortMethod = newValue
							itemModel.fetchAllItem()
						}
                    } label: {
                        Label("Sort by", systemImage: "arrow.up.arrow.down")
                    }
                }
            }

            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button(action: {
                    isStudyView = true
                }) {
                    Label("Study", systemImage: "book")
                }
                Spacer()
                Button(action: {
                    isStudyView = false
                }) {
                    Label("Quiz", systemImage: "square.and.pencil")
                }
                Spacer()
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
