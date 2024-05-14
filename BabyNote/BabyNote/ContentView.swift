//
//  ContentView.swift
//  BabyNote
//
//  Created by He Yan
//  CSC780 Final Project, Due Date: 5/14/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack {
            BabyInfoView()
            NavigationView {
                TabView {
                    NotesView()
                        .tabItem {
                            Label("Notes", systemImage: "note.text")
                        }
                    
                    SummaryView()
                        .tabItem {
                            Label("Summary", systemImage: "list.bullet")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                }
            }
        }
    }
}

// Preview provider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
