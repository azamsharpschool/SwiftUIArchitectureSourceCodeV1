//
//  String+ExtensionsTests.swift
//  OuluBankR1Tests
//
//  Created by Mohammad Azam on 2/15/25.
//

import Testing
@testable import OuluBankR1

struct String_ExtensionsTests {

    @Test(arguments: [
          "",                      // Empty string
          "123",                   // Too short
          "123-45-678",            // Missing last digit
          "123-45-6789X",          // Non-numeric character at the end
          "123-45-678X",           // Non-numeric character in the middle
          "123-45-67891",          // Too long
          "123-456-789",           // Incorrect format (missing hyphen)
          "123-45-6789 ",          // Trailing space
          " 123-45-6789",          // Leading space
          "123--45-6789",          // Double hyphen
          "123-45--6789",          // Double hyphen
          "123-45-6789-",          // Trailing hyphen
          "-123-45-6789",          // Leading hyphen
          "123 45 6789",           // Spaces instead of hyphens
          "123.45.6789",           // Periods instead of hyphens
          "123456789",             // No hyphens
          "000-00-0000",           // All zeros (invalid SSN)
          "666-00-0000",           // Starts with 666 (invalid SSN)
          "987-65-4320",           // Invalid group number (900-999)
          "123-00-6789",           // Invalid area number (000)
          "123-45-0000",           // Invalid serial number (0000)
          "ABC-DE-FGHI",           // Alphabetic characters
          "123-45-678!",           // Special character
          "123-45-6789\n",         // Newline character
          "123-45-6789\t",         // Tab character
      ])
    func invalidSSN(ssn: String) {
        #expect(!ssn.isSSN)
    }
    
        @Test(arguments: [
            "001-01-0001", // Smallest valid SSN
            "123-45-6789", // Typical valid SSN
            "456-78-9123", // Another valid SSN
            "899-99-9999", // Largest valid SSN
            "555-55-5555", // Valid SSN with repeating digits
            "111-22-3333", // Valid SSN with repeating digits
            "001-12-3456", // Valid SSN with sequential digits
            "899-01-9999", // Valid SSN with edge-case area and group numbers
            "123-01-4567", // Valid SSN with edge-case group number
            "001-99-9999", // Valid SSN with edge-case group number
        ])
        func validSSN(validSSN: String) {
            #expect(validSSN.isSSN)
        }

}
