//
//  ContentView.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var habitsViewModel = HabitsViewModel()
    
    var body: some View {
            NavigationView {
                VStack {
                            HabitListView(viewModel: habitsViewModel)
                            Button(action: {
                                let newHabit = Habit(name: "Nytt vananamn", description: "Beskrivning av vanan")
                                self.habitsViewModel.addHabit(habit: newHabit)
                            }) {
                                Text("Lägg till vana")
                            }
                        }
                .navigationTitle("Mina vanor")
            }
        }
}

struct HabitListView: View {
    @ObservedObject var viewModel: HabitsViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.habits.indices, id: \.self) { index in
                NavigationLink(destination: HabitDetailView(habit: viewModel.habits[index])) {
                    Text(viewModel.habits[index].name)
                }
            }
            .onDelete { indexSet in
                self.viewModel.removeHabit(at: indexSet.first!)
            }
        }
    }
}


struct HabitDetailView: View {
    var habit: Habit

    var body: some View {
        Text(habit.name)
            .navigationBarTitle(habit.name)
    }
}

#Preview {
    ContentView()
}
