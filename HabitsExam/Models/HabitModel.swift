//
//  HabitModel.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

import Foundation
import SwiftData

@Model
class Habit: Identifiable {
    var id: String
    var name: String
    var details: String
    var isCompleted: Bool
    var completedDates: [String]
    var streak: Int
    
    init(name: String, details: String, completedDates: [String]) {
        self.id = UUID().uuidString
        self.name = name
        self.details = details
        self.isCompleted = false
        self.completedDates = completedDates
        self.streak = 0
    }
}
