//
//  AnkiApp.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/16.
//

import SwiftUI

@main
struct AnkiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
