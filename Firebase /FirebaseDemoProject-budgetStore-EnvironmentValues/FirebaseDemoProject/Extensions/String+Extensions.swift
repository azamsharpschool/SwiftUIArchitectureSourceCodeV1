//
//  String+Extensions.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 1/10/26.
//

import Foundation

extension String {

    func normalizedDocumentID() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(
                of: "\\s+",
                with: "-",
                options: .regularExpression
            )
    }
}
