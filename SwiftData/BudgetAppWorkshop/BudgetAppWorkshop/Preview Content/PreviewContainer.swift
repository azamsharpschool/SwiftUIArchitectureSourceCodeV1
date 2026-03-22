//
//  PreviewContainer.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 3/26/24.
//

import Foundation
import SwiftData

@MainActor
var previewContainer: ModelContainer = {
    
    let container = try! ModelContainer(for: Budget.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for budget in SampleData.budgets {
        
        if budget.name == "Groceries" {
            budget.expenses = SampleData.expenses
        }
        
        container.mainContext.insert(budget)
        try! container.mainContext.save()

    }
    
    return container
    
}()

struct SampleData {
    
    static var budgets: [Budget] {
        return [Budget(name: "Groceries", limit: 400), Budget(name: "Vacation", limit: 2000)]
    }
    
    
    static var expenses: [Expense] {
        return [Expense(name: "Bread", price: 4.50, quantity: 1), Expense(name: "Milk", price: 10.0, quantity: 2)]
    }
    
}
