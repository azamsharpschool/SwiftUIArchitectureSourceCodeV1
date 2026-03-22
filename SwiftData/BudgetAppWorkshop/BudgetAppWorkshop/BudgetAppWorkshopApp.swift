//
//  BudgetAppWorkshopApp.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 3/26/24.
//

import SwiftUI
import SwiftData

@main
struct BudgetAppWorkshopApp: App {
   
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BudgetListScreen()
            }.modelContainer(for: Budget.self, isAutosaveEnabled: true)
        }
    }
}
