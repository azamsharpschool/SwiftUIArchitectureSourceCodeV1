import Foundation
import SwiftData
@testable import BudgetAppWorkshop


@MainActor
var mockContainer: ModelContainer = {
    
    let container = try! ModelContainer(for: Budget.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return container
    
}()
