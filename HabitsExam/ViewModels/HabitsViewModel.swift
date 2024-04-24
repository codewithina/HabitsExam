//
//  HabitsViewModel.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

import SwiftUI

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = [
            Habit(name: "Läsa", description: "Läs en bok i 20 minuter varje dag"),
            Habit(name: "Jogga", description: "Jogga 3 km varje morgon"),
            Habit(name: "Meditation", description: "Meditera 15 minuter varje kväll")
        ]
    
    func addHabit(habit: Habit){
        habits.append(habit)
    }
    func removeHabit(at index: Int){
        habits.remove(at: index)
    }
}
