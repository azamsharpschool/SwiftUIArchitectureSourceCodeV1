//
//  CreditScoreService.swift
//  OuluBankR1
//
//  Created by Mohammad Azam on 2/15/25.
//

import Foundation

// CANNOT CHANGE THIS CODE
struct CreditScore: Decodable {
    let score: Int?
    let lastUpdated: String
    let reportedBy: String
}

struct CreditScoreService {
    
    func getCreditScore(ssn: String) async throws -> CreditScore? {
           let (data, _) = try await URLSession.shared.data(from: URL(string: "https://island-bramble.glitch.me/api/credit-score/\(ssn)")!)
           let creditScore = try JSONDecoder().decode(CreditScore.self, from: data)
           return creditScore
    }
}
// END OF CANNOT CHANGE THIS CODE

protocol CreditScoreServiceProtocol {
    func getCreditScore(ssn: String) async throws -> CreditScore?
}

extension CreditScoreService: CreditScoreServiceProtocol { }

