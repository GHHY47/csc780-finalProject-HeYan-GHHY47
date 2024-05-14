//
//  SummaryView.swift
//  BabyNote
//
//  Created by He Yan
//  CSC780 Final Project, Due Date: 5/14/24.
//

import SwiftUI
import CoreData

struct SummaryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var babyNotes: FetchedResults<BabyNote>
    @State private var selectedDate: Date = Date()

    var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }

    var body: some View {
        VStack {
            Text(isToday ? "Today's Summary" : "Summary for \(selectedDate.formatted())")
                .font(.headline)
                .padding()
            
            let notes = babyNotes.filter({ $0.date?.formatted() == selectedDate.formatted() })
            if !notes.isEmpty {
                List {
                    ForEach(["Nursing", "Formula", "Pee", "Poop"], id: \.self) { item in
                        HStack {
                            Text(item)
                            Spacer()
                            Text("\(notes.filter({ $0.content == item }).count)")
                        }
                    }
                    
                    Section(header: Text("Last Meal")) {
                        Text(lastMealTime(notes: notes.filter { $0.content == "Nursing" || $0.content == "Formula" }))
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .cornerRadius(12)
            } else {
                Text("No data for selected date")
                    .padding()
            }

            Spacer()
            
            ZStack {
                // Conditional label for DatePicker based on selectedDate and today
                DatePicker(isToday ? "Today" : "Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                // Button return today, if selectedDate is not today
                if !isToday {
                    Button("Today") {
                        withAnimation {
                            selectedDate = Date() // Resets to current date
                        }
                    }
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
            }
        }
        .padding()
    }
    
    private func lastMealTime(notes: [BabyNote]) -> String {
        guard let lastMeal = notes.max(by: { $0.date ?? Date() < $1.date ?? Date() }) else {
            return "No meals recorded"
        }

        // Calculate duration from now
        let now = Date()
        if let mealTime = lastMeal.date {
            let components = Calendar.current.dateComponents([.hour, .minute], from: mealTime, to: now)
            if let hours = components.hour, let minutes = components.minute {
                if hours >= 0 || minutes >= 0 {
                    return "\(hours) hours \(minutes) minutes ago"
                } else {
                    return "Please check notes"
                }
            }
        }

        return "Time unknown"
    }
}

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    func formattedTime() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: self)
    }
}

