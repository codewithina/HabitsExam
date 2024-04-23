//
//  HabitsViewModel.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

import SwiftUI

class HabitsViewModel {
    @Published var habits: [Habit] = []
    
    func addHabit(habit: Habit){
        habits.append(habit)
    }
    func removeHabit(at index: Int){
        habits.remove(at: index)
    }
}
