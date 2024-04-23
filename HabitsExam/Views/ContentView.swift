//
//  ContentView.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

import SwiftUI

struct ContentView: View {
    
    let habits = [
           Habit(name: "Borsta tänderna"),
           Habit(name: "Dricka vatten"),
           Habit(name: "Träna yoga")
       ]
    
    var body: some View {
            NavigationView {
                List(habits, id: \.name) { habit in
                    NavigationLink(destination: HabitDetailView(habit: habit)) {
                        Text(habit.name)
                    }
                }
                .navigationTitle("Mina vanor")
            }
        }
}

struct HabitListView: View{
    @ObservedObject var viewModel: HabitsViewModel
    
    var body: some View {
        List {
                    ForEach(viewModel.habits.indices, id: \.self) { index in
                        Text(self.viewModel.habits[index].name)
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
