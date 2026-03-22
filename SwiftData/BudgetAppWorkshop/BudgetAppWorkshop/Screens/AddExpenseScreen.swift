//
//  AddExpenseScreen.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 3/27/24.
//

import SwiftUI
import SwiftData

struct ExpenseConfig {
    
    var name: String = ""
    var price: Double?
    var quantity: Int = 1
    
    var isValid: Bool {
        guard let price = price else { return false }
        return !name.isEmptyOrWhitespace && price > 0 && quantity > 0
    }
}

struct AddExpenseScreen: View {
    
    let budget: Budget
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var expenseConfig = ExpenseConfig()
    
    private func saveExpense() {
        do {
            guard let price = expenseConfig.price else { return }
            
            let expense = Expense(name: expenseConfig.name, price: price, quantity: expenseConfig.quantity)
            
            budget.expenses?.append(expense)
            try context.save()
            dismiss()
        } catch {
        }
    }
    
    var body: some View {
        Form {
            Section("Add Expense") {
                
                TextField("Expense name", text: $expenseConfig.name)
                TextField("Expense price", value: $expenseConfig.price, format: .number)
                TextField("Expense quantity", value: $expenseConfig.quantity, format: .number)
                 
                Button(action: {
                    // save expenses
                    if expenseConfig.isValid {
                        // save expenses
                        saveExpense()
                    }
                }, label: {
                    Text("Save Expense")
                        .frame(maxWidth: .infinity)
                }).buttonStyle(.borderedProminent)
                    .listRowSeparator(.hidden)
                
            }
        }.navigationTitle("Add Expense")
    }
}

struct AddExpenseScreenContainer: View {
    
    @Query private var budgets: [Budget]
    
    var body: some View {
        AddExpenseScreen(budget: budgets[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        AddExpenseScreenContainer()
    }.modelContainer(previewContainer)
}
