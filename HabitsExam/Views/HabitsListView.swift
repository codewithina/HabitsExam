//
//  HabitsListView.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-26.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var context
    @Query private var habits: [Habit]
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(identifier: "Europe/Stockholm")
            return formatter
        }()
    
    var body: some View {
        List {
            ForEach(habits.indices, id: \.self) { index in
                NavigationLink(destination: HabitDetailView(habit: habits[index])) {
                    HStack {
                        Button(action: {
                            toggleHabitCompletion(at: index)
                        }) {
                            Image(systemName: habits[index].isCompleted ? "checkmark.square.fill" : "square")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Text(habits[index].name)
                        Spacer()
                        Text("\(habits[index].streak) 🏆")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete { indexSet in
                            indexSet.forEach { index in
                                // Ta bort rätt habit med context.delete
                                context.delete(habits[index])
                            }
                        }
        }
        .onAppear {
            // Add fictive completion dates
            // habits[2].completedDates.append("2024-04-21")
            checkTodaysToggleCompletion()
            calculateStreaks()
            
            //Controlling dates
            printSavedDates()
        }
    }
    
    // Just a control function
    func printSavedDates(){
        for habit in habits {
            print("Habit: \(habit.name)")
            print("Completed Dates:")
            for date in habit.completedDates {
                print(date)
            }
            print("---")
        }
    }
    
    func todaysDate() -> String {
        let todayDate = Date()
        let todayDateString = dateFormatter.string(from: todayDate)
        return todayDateString
    }
    
    func checkTodaysToggleCompletion() {
        let todayDateString = todaysDate()
        
        for index in habits.indices {
            let habit = habits[index]
            if habit.completedDates.contains(todayDateString) {
                habits[index].isCompleted = true
            } else {
                habits[index].isCompleted = false
            }
        }
    }
    
    func toggleHabitCompletion(at index: Int) {
        let habit = habits[index]
        
        let todayDateString = todaysDate()
        
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

struct HabitDetailView: View {
    var habit: Habit
    
    var body: some View {
        Text(habit.details)
            .navigationBarTitle(habit.name)
    }
}
