//
//  BabyNoteApp.swift
//  BabyNote
//
//  Created by He Yan
//  CSC780 Final Project, Due Date: 5/14/24.
//

import SwiftUI

@main
struct BabyNoteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
