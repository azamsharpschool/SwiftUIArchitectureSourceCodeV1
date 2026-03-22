//
//  BudgetListScreen.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 3/26/24.
//

import SwiftUI
import SwiftData

struct BudgetListScreen: View {
    
    @Query private var budgets: [Budget]
    @State private var isPresented: Bool = false
    
    private var total: Double {
        budgets.reduce(0) { result, budget in
            result + budget.limit
        }
    }
    
    var body: some View {
        Group {
            if budgets.isEmpty {
                ContentUnavailableView("No Budgets Found", systemImage: "folder")
            } else {
                List {
                    Text(total, format: .currency(code: Locale.currencyCode))
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    ForEach(budgets) { budget in
                        NavigationLink {
                            BudgetDetailScreen(budget: budget)
                        } label: {
                            BudgetCellView(budget: budget)
                        }
                    }
                }
            }
        }
        .accessibilityIdentifier("budgetCollectionView")
        .listStyle(.plain)
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Budget") {
                        isPresented = true
                    }.accessibilityIdentifier("addBudgetButton")
                }
            }
            .sheet(isPresented: $isPresented, content: {
                NavigationStack {
                    AddBudgetScreen()
                }
            })
            
    }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
    }.modelContainer(previewContainer)
}


struct BudgetCellView: View {
    
    let budget: Budget
    
    var body: some View {
        HStack {
            Text(budget.name)
            Spacer()
            Text(budget.limit, format: .currency(code: Locale.currencyCode))
        }
    }
}
