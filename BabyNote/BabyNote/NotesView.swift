//
//  NotesView.swift
//  BabyNote
//
//  Created by He Yan 
//  CSC780 Final Project, Due Date: 5/14/24.
//


import SwiftUI
import CoreData

struct NotesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var notes: [BabyNote] = []
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date() // For tracking selected time
    @State private var showPopup: Bool = false // For control popup
    @State private var currentNoteContent: String? // Temp note content var

    var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack {
            ZStack {
                // Conditional label for DatePicker based on selectedDate and today
                DatePicker(isToday ? "Today" : "Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)

                // Button return today, if selectedDate is not today
                if !isToday {
                    Button("Today") {
                        withAnimation {
                            selectedDate = Date() // Reset to current date
                            fetchNotes() // Update data
                        }
                    }
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
            }
            List {
                ForEach(filterNotes(), id: \.self) { note in
                    HStack {
                        if let date = note.date {
                            Text(date, formatter: Self.dateFormatter)
                        } else {
                            Text("Date NA")
                        }
                        Text(note.content ?? "No content")
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("Baby Notes")
            ScrollView(.horizontal) {
                HStack {
                    ActionButton(title: "Nursing", content: "Nursing", showPopup: $showPopup, currentNoteContent: $currentNoteContent)
                    ActionButton(title: "Formula", content: "Formula", showPopup: $showPopup, currentNoteContent: $currentNoteContent)
                    ActionButton(title: "Sleep", content: "Sleep", showPopup: $showPopup, currentNoteContent: $currentNoteContent)
                    ActionButton(title: "Wake Up", content: "Wake Up", showPopup: $showPopup, currentNoteContent: $currentNoteContent)
                    ActionButton(title: "Pee", content: "Pee", showPopup: $showPopup, currentNoteContent: $currentNoteContent)
                    ActionButton(title: "Poop", content: "Poop", showPopup: $showPopup, currentNoteContent: $currentNoteContent)
                }
            }.padding(10)
            
            Spacer()
        }
        .overlay(
            showPopup ? popupView() : nil
        )
        .onAppear {
            fetchNotes()
        }
    }

    private func fetchNotes() {
        let request: NSFetchRequest<BabyNote> = BabyNote.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BabyNote.date, ascending: true)]
        
        do {
            notes = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }

    private func filterNotes() -> [BabyNote] {
        notes.filter { $0.date?.formatted() == selectedDate.formatted() }
    }

    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
                fetchNotes()  // Fetch notes after deleting to update the view
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    @ViewBuilder
    private func popupView() -> some View {
        VStack(spacing: 20) {
            DatePicker(">>>", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())

            HStack(spacing: 10) {
                Button("Cancel") {
                    showPopup = false
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Add Note") {
                    addNoteWithContent(currentNoteContent ?? "No Content")
                    showPopup = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

            }
        }
        .frame(width: 300, height: 350) // Adjusted size for popupview
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
    
    struct ActionButton: View {
        let title: String
        let content: String
        @Binding var showPopup: Bool
        @Binding var currentNoteContent: String?
        var body: some View {
            Button(title) {
                currentNoteContent = content
                showPopup = true
            }
            .padding(10)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }

    func addNoteWithContent(_ content: String) {
        let newNote = BabyNote(context: viewContext)
        newNote.id = UUID()
        newNote.content = content
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        newNote.date = calendar.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute))
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchNotes()  // Fetch notes after saving to update the view
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
