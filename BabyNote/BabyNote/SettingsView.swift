//
//  SettingView.swift
//  BabyNote
//
//  Created by He Yan
//  CSC780 Final Project, Due Date: 5/14/24.
//

import SwiftUI
import Foundation
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var babyNotes: FetchedResults<BabyNote>
    
    @State private var babyName: String = ""
    @State private var babyBirthday: Date = Date()
    
    var body: some View {
        VStack (alignment: .leading) {
            TextField("Enter baby name", text: $babyName)
                .onAppear {
                    if let babyNote = babyNotes.first(where: { $0.babyName != nil }) {
                        babyName = babyNote.babyName ?? ""
                    }
                }
            
            DatePicker("Baby birthday", selection: $babyBirthday, displayedComponents: .date)
                .onAppear {
                    if let babyNote = babyNotes.first(where: { $0.babyName != nil }) {
                        babyBirthday = babyNote.babyBirthday ?? Date()
                    }
                }
            
            Button(action: {
                if let babyNote = babyNotes.first(where: { $0.babyName != nil }) {
                    babyNote.babyName = babyName
                    babyNote.babyBirthday = babyBirthday
                } else {
                    let newNote = BabyNote(context: viewContext)
                    newNote.id = UUID()
                    newNote.content = "BabyInfo"
                    newNote.date = Date()
                    newNote.babyName = babyName
                    newNote.babyBirthday = babyBirthday
                }
                saveContext()
            }) {
                Text(babyNotes.isEmpty || babyName != babyNotes.first(where: { $0.babyName != nil })?.babyName || babyBirthday != babyNotes.first(where: { $0.babyName != nil })?.babyBirthday ? "Save" : "Saved")
                    .padding(10)
                    .frame(maxWidth: .infinity) // Set max width
                    .background(babyNotes.isEmpty || babyName != babyNotes.first(where: { $0.babyName != nil })?.babyName || babyBirthday != babyNotes.first(where: { $0.babyName != nil })?.babyBirthday ? Color.blue : Color.gray) // Set color based on condition
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(babyNotes.isEmpty || babyName == babyNotes.first(where: { $0.babyName != nil })?.babyName && babyBirthday == babyNotes.first(where: { $0.babyName != nil })?.babyBirthday) // Disable button if saved
            }
            Spacer()
        }
        .padding(50)
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

