//
//  BudgetFacade.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 1/14/26.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
class BudgetStoreFacade {
    
    private let store: BudgetStoreProtocol
    
    init(_ store: BudgetStoreProtocol) {
        self.store = store
    }
    
    var budgets: [Budget] { store.budgets }
    
    func createBudget(budget: Budget, for uid: String) throws {
        try store.createBudget(budget: budget, for: uid)
    }
    
    func startListening(uid: String) {
        store.startListening(uid: uid)
    }
    
    func stopListening() {
        store.stopListening()
    }
    
}
