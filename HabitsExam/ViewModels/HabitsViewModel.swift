//
//  HabitsViewModel.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

import SwiftUI

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = [
        Habit(name: "Läsa", details: "Läs en bok i 20 minuter varje dag", completedDates: []),
        Habit(name: "Jogga", details: "Jogga 3 km varje morgon", completedDates: ["2024-04-21","2024-04-22","2024-04-23","2024-04-24","2024-04-20"]),
        Habit(name: "Meditation", details: "Meditera 15 minuter varje kväll", completedDates: []),
        Habit(name: "Yoga", details: "Gör en 30 minuters yogaövning varje eftermiddag", completedDates: []),
        Habit(name: "Grönsaker", details: "Ät minst en portion grönsaker till varje måltid", completedDates: []),
        Habit(name: "Skriv dagbok", details: "Skriv i din dagbok varje kväll innan du går och lägger dig",  completedDates: ["2024-04-13","2024-04-17","2024-04-15","2024-04-16","2023-04-18","2023-04-13","2023-04-17","2023-04-15","2023-04-16"]),
        Habit(name: "Dricka grönt te", details: "Drick en kopp grönt te varje morgon", completedDates: []),
        Habit(name: "Stretching", details: "Gör en kort stretchingrutin varje morgon för att vakna upp kroppen", completedDates: []),
        Habit(name: "Planera nästa dag", details: "Planera dina uppgifter och mål för nästa dag varje kväll", completedDates: [])
    ]
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(identifier: "Europe/Stockholm")
            return formatter
        }()
    
    func addHabit(habit: Habit){
        habits.append(habit)
    }
    
    func removeHabit(at index: Int){
        habits.remove(at: index)
    }
    
    func toggleHabitCompletion(at index: Int) {
        let habit = habits[index]
        
        let todayDate = Date()
        let todayDateString = dateFormatter.string(from: todayDate)
        
        if !habit.isCompleted {
            if !habit.completedDates.contains(todayDateString) {
                habits[index].completedDates.append(todayDateString)
                habits[index].streak += 1
                calculateStreaks()
            }
        } else {
            if let indexToRemove = habits[index].completedDates.firstIndex(of: todayDateString) {
                habits[index].completedDates.remove(at: indexToRemove)
                habits[index].streak -= 1
                calculateStreaks()
            }
        }
        habits[index].isCompleted.toggle()
    }
    
    func calculateStreaks() {
        let todayDate = Date()

        for index in habits.indices {
            let completedDates = habits[index].completedDates.sorted().reversed()
            var streakCount = 0
            var currentDate = todayDate
            var yesterday = Calendar.current.date(byAdding: .day, value: -1, to: todayDate) ?? Date()

            for dateString in completedDates {
                if dateFormatter.string(from: currentDate) == dateString {
                    streakCount += 1
                    if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) {
                        currentDate = newDate
                    } else {
                        break
                    }
                }
                else if dateFormatter.string(from: yesterday) == dateString {
                    streakCount += 1
                    if let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: yesterday) {
                        yesterday = dayBefore
                    } else {
                        break
                    }
                }else {
                    break 
                }
            }

            habits[index].streak = streakCount
        }
    }
}
