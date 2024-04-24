//
//  ContentView.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

/*
 TODO: Implementera funktionen för att hämta data från API.
 - En lista över alla vanor som användaren har lagt till.
 - Möjlighet att lägga till nya vanor genom att ange namnet på vanan.
 - Möjlighet att markera om en vana har utförts varje dag genom att klicka på en knapp bredvid vanans namn.
 - Lagring av hur långt en "streak" är för varje vana, dvs. hur många dagar i rad vanan har utförts.
 - En sammanställning av användarens utförda vanor för varje dag, vecka och månad.
 - Möjlighet att ställa in påminnelser för varje vana, så att användaren får en påminnelse att utföra vanan vid en specifik tidpunkt varje dag.
 */

import SwiftUI

struct ContentView: View {
    @StateObject var habitsViewModel = HabitsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HabitListView(viewModel: habitsViewModel)
            }
            .navigationTitle("Mina vanor")
            .navigationBarItems(trailing:
                                    Button(action: {
                let newHabit = Habit(name: "Nytt vananamn", description: "Beskrivning av vanan")
                self.habitsViewModel.addHabit(habit: newHabit)
            }) {
                Text("Lägg till vana")
                Image(systemName: "plus")
            }
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
        Text(habit.description)
            .navigationBarTitle(habit.name)
    }
}

#Preview {
    ContentView()
}
