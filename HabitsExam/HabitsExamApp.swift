//
//  HabitsExamApp.swift
//  HabitsExam
//
//  Created by Ina Burström on 2024-04-22.
//

import SwiftUI
import SwiftData

@main
struct HabitsExamApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Habit.self)
    }
}
