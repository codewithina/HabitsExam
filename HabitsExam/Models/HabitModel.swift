//
//  HabitModel.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

import Foundation

struct Habit {
    var name: String
    var description: String
    var isCompleted: Bool = false
    var completedDates: [String]
    var streak: Int = 0
}
