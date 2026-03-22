//
//  BudgetStore.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 1/10/26.
//

import Foundation
import Observation
import FirebaseFirestore

protocol BudgetStoreProtocol {
    var budgets: [Budget] { get }
    
    func createBudget(budget: Budget, for uid: String) throws
    func startListening(uid: String)
    func stopListening()
}

@Observable
final class PreviewBudgetStore: BudgetStoreProtocol {
    
    var budgets: [Budget] = [
        Budget(name: "Colorado Vacation", limit: 500)
    ]
    
    func createBudget(budget: Budget, for uid: String) throws {
        budgets.append(budget)
    }
    
    func startListening(uid: String) {
        //
    }
    
    func stopListening() {
        //
    }
}

@Observable
final class BudgetStore: BudgetStoreProtocol {
    
    private(set) var budgets: [Budget] = []
    private let firestore: Firestore
    private var listener: ListenerRegistration?
    
    init(firestore: Firestore = Firestore.firestore()) {
        self.firestore = firestore
    }
    
    func createBudget(budget: Budget, for uid: String) throws {
        try firestore.collection("users")
            .document(uid)
            .collection("budgets")
            .document(budget.name.normalizedDocumentID())
            .setData(from: budget)
    }
    
    func startListening(uid: String) {
        listener?.remove()
        
        listener = firestore.collection("users")
            .document(uid)
            .collection("budgets")
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self, let snapshot else { return }
                
                self.budgets = snapshot.documents.compactMap {
                    try? $0.data(as: Budget.self)
                }
            }
    }
    
    func stopListening() {
        listener?.remove()
        listener = nil
        budgets = []
    }
    
    deinit {
        listener?.remove()
    }
}
