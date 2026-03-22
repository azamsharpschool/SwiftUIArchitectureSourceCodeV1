//
//  Budget.swift
//  TestingSwiftDataModels
//
//  Created by Mohammad Azam on 10/4/25.
//

import Foundation
import SwiftData

@Model
class Budget {
    var name: String
    var limit: Double
    
    init(name: String, limit: Double) {
        self.name = name
        self.limit = limit
    }
}
