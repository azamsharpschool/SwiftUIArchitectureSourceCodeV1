//
//  BudgetError.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 3/27/24.
//

import Foundation

enum BudgetError: LocalizedError {
    case duplicateName
    
    var errorDescription: String? {
        switch self {
            case .duplicateName:
                return "The budget name must be unique."
        }
    }
}
