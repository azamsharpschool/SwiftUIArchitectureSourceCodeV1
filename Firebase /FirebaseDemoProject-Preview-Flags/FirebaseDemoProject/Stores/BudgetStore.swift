//
//  BudgetStore.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 1/10/26.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
final class BudgetStore {
    
    private(set) var budgets: [Budget] = []
    private let firestore: Firestore
    private var listener: ListenerRegistration?
    
    let isPreview: Bool
    
    init(firestore: Firestore = Firestore.firestore(), isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1") {
        self.firestore = firestore
        self.isPreview = isPreview
        
        if isPreview {
            self.budgets = [Budget(name: "Vacation", limit: 500)]
        }
    }
    
    func createBudget(budget: Budget, for uid: String) throws {
        
        if isPreview {
            self.budgets.append(budget)
            return
        }
        
        try firestore.collection("users")
            .document(uid)
            .collection("budgets")
            .document(budget.name.normalizedDocumentID())
            .setData(from: budget)
    }
    
    func startListening(uid: String) {
        
        guard !isPreview else { return }
        
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
        
        guard isPreview else { return }
        
        listener?.remove()
        listener = nil
        budgets = []
    }
    
    deinit {
        listener?.remove()
    }
}
