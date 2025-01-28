//
//  ToDoListEffectiveMobileApp.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 28/01/25.
//

import SwiftUI

@main
struct ToDoListEffectiveMobileApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
