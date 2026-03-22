//
//  SortingPresentingLogic.swift
//  TestingPresentationLogic
//
//  Created by Mohammad Azam on 10/4/25.
//

import SwiftUI

enum SortOption {
    case ascending
    case descending
}

struct CustomerSorter {
    func sort(_ customers: [String], by option: SortOption) -> [String] {
        switch option {
        case .ascending:
            customers.sorted(by: <)
        case .descending:
            customers.sorted(by: >)
        }
    }
}


struct SortingPresentingLogic: View {
    
    @State private var sortOption: SortOption = .ascending
    private let sorter = CustomerSorter()
    
    @State private var customers = [
        "John Doe",
        "Emily Smith",
        "Michael Brown",
        "Sophia Johnson",
        "David Wilson"
    ]

    
    var body: some View {
        List {
            Button(sortOption == .ascending ? "Sort Descending": "Sort Ascending") {
                // Toggle sort option
                sortOption = (sortOption == .ascending) ? .descending : .ascending
            }
            
            ForEach(customers, id: \.self) { customer in
                Text(customer)
            }
        }
        .onChange(of: sortOption, initial: true) {
            
            customers = sorter.sort(customers, by: sortOption)
            /* // moved the logic into CustomerSorter
            switch sortOption {
            case .ascending:
                customers.sort(by: <)
            case .descending:
                customers.sort(by: >)
            } */
        }
    }
}

#Preview {
    SortingPresentingLogic()
}
