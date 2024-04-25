//
//  ContentView.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

/*
 TODO: För att uppnå VG
 x En lista över alla vanor som användaren har lagt till.
 x Spara vanor och annan info i appen.
 x Möjlighet att lägga till nya vanor genom att ange namnet på vanan.
 x Möjlighet att markera om en vana har utförts varje dag genom att klicka på en knapp bredvid vanans namn.
 x Lagring av hur långt en "streak" är för varje vana, dvs. hur många dagar i rad vanan har utförts.
 - En sammanställning av användarens utförda vanor för varje dag, vecka och månad.
 - Möjlighet att ställa in påminnelser för varje vana, så att användaren får en påminnelse att utföra vanan vid en specifik tidpunkt varje dag.

 TODO: Extras
 - Lägg till sortering avklarade/återstående för dagen.
 - När det är ny dag, återställs markeringar och alal habits läggs i återstående.
 */

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showingAddHabitView = false
    @State private var newHabitName = ""
    @State private var newHabitDetails = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HabitListView()
            }
            .navigationTitle("Mina vanor")
            .navigationBarItems(trailing:
                                    Button(action: {
                showingAddHabitView = true
            }) {
                Text("Ny vana")
                Image(systemName: "plus")
            }
                .sheet(isPresented: $showingAddHabitView, content: {
                                AddHabitView(newHabitName: $newHabitName, newHabitDetails: $newHabitDetails, isPresented: $showingAddHabitView)
                            })
            )
        }
    }
}

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
            calculateStreaks()
        }
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

struct HabitDetailView: View {
    var habit: Habit
    
    var body: some View {
        Text(habit.details)
            .navigationBarTitle(habit.name)
    }
}

struct AddHabitView: View {
    @Environment(\.modelContext) private var context
    
    @Binding var newHabitName: String
    @Binding var newHabitDetails: String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Namn", text: $newHabitName)
                    .padding()
                TextField("Beskrivning", text: $newHabitDetails)
                    .padding()
                Spacer()
                Button("Lägg till") {
                    addHabit()
                    newHabitName = ""
                    newHabitDetails = ""
                    isPresented = false
                }
                .padding()
            }
            .navigationTitle("Lägg till ny vana")
            .navigationBarItems(trailing:
                                    Button("Avbryt") {
                                        isPresented = false
                                    }
            )
        }
    }
    
    func addHabit() {
        let newHabit = Habit(name: newHabitName, details: newHabitDetails, completedDates: [])
        context.insert(newHabit)
    }
}

#Preview {
    ContentView()
}
