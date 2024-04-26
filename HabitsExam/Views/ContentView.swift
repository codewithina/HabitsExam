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
