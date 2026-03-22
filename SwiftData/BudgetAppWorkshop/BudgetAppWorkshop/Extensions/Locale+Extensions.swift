//
//  Locale+Extensions.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 3/26/24.
//

import Foundation

extension Locale {
    
    static var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
}
