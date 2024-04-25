//
//  ContentView.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

/*
 TODO: För att uppnå VG
 x En lista över alla vanor som användaren har lagt till.
 - Spara vanor och annan info i appen.
 x Möjlighet att lägga till nya vanor genom att ange namnet på vanan.
 - Möjlighet att markera om en vana har utförts varje dag genom att klicka på en knapp bredvid vanans namn.
 - Lagring av hur långt en "streak" är för varje vana, dvs. hur många dagar i rad vanan har utförts.
 - En sammanställning av användarens utförda vanor för varje dag, vecka och månad.
 - Möjlighet att ställa in påminnelser för varje vana, så att användaren får en påminnelse att utföra vanan vid en specifik tidpunkt varje dag.

 TODO: Extras
 - Lägg till sortering avklarade/återstående för dagen.
 - När det är ny dag, återställs markeringar och alal habits läggs i återstående.
 */

import SwiftUI

struct ContentView: View {
    @StateObject var habitsViewModel = HabitsViewModel()
    @State private var showingAddHabitView = false
    @State private var newHabitName = ""
    @State private var newHabitDescription = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HabitListView(viewModel: habitsViewModel)
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
                                AddHabitView(newHabitName: $newHabitName, newHabitDescription: $newHabitDescription, habitsViewModel: habitsViewModel, isPresented: $showingAddHabitView)
                            })
            )
        }
    }
}

struct HabitListView: View {
    @ObservedObject var viewModel: HabitsViewModel
    
    var body: some View {
        List {
            
            ForEach(viewModel.habits.indices, id: \.self) { index in
                NavigationLink(destination: HabitDetailView(habit: viewModel.habits[index])) {
                    HStack {
                        Button(action: {
                            viewModel.toggleHabitCompletion(at: index)
                            for habit in viewModel.habits {
                                print("Habit: \(habit.name)")
                                for completionDate in habit.completedDates {
                                    print("Completion Date: \(completionDate)")
                                }
                            }
                        }) {
                            Image(systemName: viewModel.habits[index].isCompleted ? "checkmark.square.fill" : "square")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Text(viewModel.habits[index].name)
                        Spacer()
                        Text("\(viewModel.habits[index].streak) 🏆")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete { indexSet in
                self.viewModel.removeHabit(at: indexSet.first!)
            }
        }
        .onAppear {
                viewModel.calculateStreaks()
        }
    }
}


struct HabitDetailView: View {
    var habit: Habit
    
    var body: some View {
        Text(habit.description)
            .navigationBarTitle(habit.name)
    }
}

struct AddHabitView: View {
    @Binding var newHabitName: String
    @Binding var newHabitDescription: String
    @ObservedObject var habitsViewModel: HabitsViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Namn", text: $newHabitName)
                    .padding()
                TextField("Beskrivning", text: $newHabitDescription)
                    .padding()
                Spacer()
                Button("Lägg till") {
                    let newHabit = Habit(name: newHabitName, description: newHabitDescription, isCompleted: false, completedDates: [])
                    habitsViewModel.addHabit(habit: newHabit)
                    newHabitName = ""
                    newHabitDescription = ""
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
}

#Preview {
    ContentView()
}
