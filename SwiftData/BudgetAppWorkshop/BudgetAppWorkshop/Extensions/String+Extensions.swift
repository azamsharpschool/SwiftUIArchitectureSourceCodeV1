//
//  String+Extensions.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 3/26/24.
//

import Foundation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
