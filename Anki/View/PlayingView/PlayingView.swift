//
//  PlayingView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/17.
//

import SwiftUI
import CoreData

struct PlayingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@EnvironmentObject var errorHandling: ErrorHandling
	private var items = [Item]()

	let context = PersistenceController.shared.container.viewContext

	let openAddItemView: () -> Void

	init(openAddItemView: @escaping () -> Void) {
		self.openAddItemView = openAddItemView
		self.items = fetchAllItem()
	}

	@State private var isStudyView: Bool = true

    var body: some View {
        VStack {
			if isStudyView {
				StudyView(items: items, goBackAndAddItem: goBackAndAddItem)
			} else {
				QuizView(items: items, goBackAndAddItem: goBackAndAddItem)
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
						Text("Sort by:")
							.fontWeight(.bold)
						Button("front", action: {})
						Button("back", action: {})
						Button("time", action: {})
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
		self.presentationMode.wrappedValue.dismiss()
		openAddItemView()
	}

	// 0 => time, 1 => front, 2 => back
	private func fetchAllItem(sortMethod: Int = 0) -> [Item] {
		var result: [Item] = []
		do {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
			var sectionSortDescriptor: NSSortDescriptor
			if sortMethod == 0 {
				sectionSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
			} else if sortMethod == 1 {
				sectionSortDescriptor = NSSortDescriptor(key: "front", ascending: true)
			} else {
				sectionSortDescriptor = NSSortDescriptor(key: "back", ascending: true)
			}
			fetchRequest.sortDescriptors = [sectionSortDescriptor]
			result = try context.fetch(fetchRequest) as! [Item]
		} catch {
			self.errorHandling.handleError(error: error)
		}
		return result
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
