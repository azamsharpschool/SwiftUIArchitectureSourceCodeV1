//
//  PlatziStore.swift
//  Platzi
//
//  Created by Mohammad Azam on 9/14/25.
//

import Foundation
import Observation

@MainActor
@Observable
class PlatziStore {
    
    var categories: [Category] = []
    var locations: [Location] = []
    
    let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func loadCategories() async throws {
        categories = try await httpClient.loadCategories()
    }
}

