//
//  BudgetDetailScreen.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 3/27/24.
//

import SwiftUI
import SwiftData

struct BudgetDetailScreen: View {
    
    @Bindable var budget: Budget
    @Environment(\.modelContext) private var context
    @State private var expenseConfig = ExpenseConfig()
    @State private var isPresented: Bool = false
    
    @Query private var expenses: [Expense] = []
    
    init(budget: Budget) {
        self.budget = budget
        let budgetId = self.budget.persistentModelID
        
        let predicate = #Predicate<Expense> {
            if let budget = $0.budget {
                return budget.persistentModelID == budgetId
            } else {
                return false
            }
        }
        
        _expenses = Query(filter: predicate)
    }
    
    private var insufficientFundsColor: Color {
        budget.remaining < 0 ? .red: .primary
    }
    
    private func deleteExpense(indexSet: IndexSet) {
        for index in indexSet.sorted(by: >) { // Iterate in reverse order
            let expenseToDelete = budget.expenses?[index]
            budget.expenses?.remove(at: index) // Remove from the array
            
            if let expenseToDelete {
                context.delete(expenseToDelete) // Delete from the context
            }
        }
        do {
            try context.save() // Save the changes
        } catch {
        }
    }

    
    var body: some View {
        
        VStack {

            Text(budget.limit, format: .currency(code: Locale.currencyCode))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .font(.headline)
             
            
            Form {
                Section("Budget") {
                     TextField("Budget name", text: $budget.name)
                     TextField("Budget limit", value: $budget.limit, format: .currency(code: Locale.currencyCode))
                }
                
                Section("Expenses") {
                    List {
                        
                        VStack {
                            Text("Spent: \(Text(budget.spent, format: .currency(code: Locale.currencyCode)))")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("Remaining: \(Text(budget.remaining, format: .currency(code: Locale.currencyCode)))")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundStyle(insufficientFundsColor)
                        }
                        
                        ForEach(expenses) { expense in
                            ExpenseCellView(expense: expense)
                        }.onDelete(perform: deleteExpense)
                    }
                }
                
            }.navigationTitle(budget.name)
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Expense") {
                    isPresented = true
                }
            }
        }.sheet(isPresented: $isPresented) {
            NavigationStack {
                AddExpenseScreen(budget: budget)
            }
        }
        
    }
}


struct BudgetDetailScreenContainer: View {
    
    @Query(sort: \Budget.name, order: .forward) private var budgets: [Budget]
    
    var body: some View {
        // SampleData.budgets simple returns a hard-coded array of budgets
        BudgetDetailScreen(budget: budgets[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        BudgetDetailScreenContainer()
    }.modelContainer(previewContainer)
}


struct ExpenseCellView: View {
    
    let expense: Expense
    
    var body: some View {
        HStack {
            Text("\(Text(expense.name)) (\(expense.quantity))")
            Spacer()
            Text(expense.total, format: .currency(code: Locale.currencyCode))
        }
    }
}

