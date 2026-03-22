//
//  GreenPlaceStore.swift
//  MyGreenPlace
//
//  Created by Mohammad Azam on 1/23/26.
//

import Foundation
import Observation

@Observable
class GreenPlaceStore {
    
    private(set) var vegetables: [Vegetable] = []
    
    func loadVegetables() async throws {
        guard let url = Bundle.main.url(forResource: "vegetables", withExtension: "json") else {
            throw NSError(domain: "VegetableLoader", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "vegetables.json not found in bundle"
            ])
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        vegetables = try decoder.decode([Vegetable].self, from: data)
    }
    
}
