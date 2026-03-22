//
//  HTTPClient.swift
//  GroceryApp
//
//  Created by Mohammad Azam on 5/7/23.
//

import Foundation

protocol HTTPClientProtocol {
    func loadCategories() async throws -> [Category]
}

struct HTTPClient: HTTPClientProtocol {
    func loadCategories() async throws -> [Category] {
        [] 
    }
}
