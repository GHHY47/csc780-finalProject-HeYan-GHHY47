//
//  BabyInfo.swift
//  BabyNote
//
//  Created by He Yan
//  CSC780 Final Project, Due Date: 5/14/24.
//

import SwiftUI
import CoreData

struct BabyInfoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var babyNotes: FetchedResults<BabyNote>

    var body: some View {
        VStack {
            if let baby = babyNotes.first(where: { $0.babyName != nil }) {
                Text("Baby Name: \(baby.babyName ?? "")")
                Spacer()
                Text("Age: \(calculateAge(baby.babyBirthday ?? Date()))")
            } else {
                Text("Add Baby Info in Setting")
            }
        }
        .frame(height: 50)
        .font(.headline)
        .foregroundColor(.black)
    }

    func calculateAge(_ birthday: Date) -> String {
        let ageComponents = Calendar.current.dateComponents([.year, .month, .day], from: birthday, to: Date())
        return "\(ageComponents.year ?? 0) Year, \(ageComponents.month ?? 0) Month, \(ageComponents.day ?? 0) Day"
    }
}
