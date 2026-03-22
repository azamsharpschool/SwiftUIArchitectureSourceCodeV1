//
//  Expense.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 12/11/24.
//

import Foundation
import SwiftData

@Model
class Expense {
    
    var name: String = ""
    var price: Double = 0.0
    var quantity: Int = 1
    var budget: Budget? 
    
    var total: Double {
        price * Double(quantity)
    }
    
    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}
