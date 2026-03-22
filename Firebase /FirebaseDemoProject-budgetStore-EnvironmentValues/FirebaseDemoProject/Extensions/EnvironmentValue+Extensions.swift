//
//  EnvironmentValue+Extensions.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 1/14/26.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var budgetStore: BudgetStoreProtocol = BudgetStore()
}
