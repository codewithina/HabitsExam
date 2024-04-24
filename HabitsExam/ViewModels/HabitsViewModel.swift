//
//  HabitsViewModel.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

import SwiftUI

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = [
        Habit(name: "Läsa", description: "Läs en bok i 20 minuter varje dag", isCompleted: false, completedDates: []),
        Habit(name: "Jogga", description: "Jogga 3 km varje morgon", isCompleted: false, completedDates: []),
        Habit(name: "Meditation", description: "Meditera 15 minuter varje kväll", isCompleted: false, completedDates: []),
        Habit(name: "Yoga", description: "Gör en 30 minuters yogaövning varje eftermiddag", isCompleted: false, completedDates: []),
        Habit(name: "Grönsaker", description: "Ät minst en portion grönsaker till varje måltid", isCompleted: false, completedDates: []),
        Habit(name: "Skriv dagbok", description: "Skriv i din dagbok varje kväll innan du går och lägger dig", isCompleted: false, completedDates: []),
        Habit(name: "Dricka grönt te", description: "Drick en kopp grönt te varje morgon", isCompleted: false, completedDates: []),
        Habit(name: "Stretching", description: "Gör en kort stretchingrutin varje morgon för att vakna upp kroppen", isCompleted: false, completedDates: []),
        Habit(name: "Planera nästa dag", description: "Planera dina uppgifter och mål för nästa dag varje kväll", isCompleted: false, completedDates: [])
    ]
    
    func addHabit(habit: Habit){
        habits.append(habit)
    }
    func removeHabit(at index: Int){
        habits.remove(at: index)
    }
    
    func toggleHabitCompletion(at index: Int) {
            habits[index].isCompleted.toggle()
        }
}
