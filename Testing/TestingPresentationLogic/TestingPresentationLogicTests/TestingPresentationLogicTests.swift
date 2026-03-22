//
//  TestingPresentationLogicTests.swift
//  TestingPresentationLogicTests
//
//  Created by Mohammad Azam on 10/4/25.
//

import Testing
@testable import TestingPresentationLogic

struct CustomerSorterTests {
    
    let sorter = CustomerSorter()
    let customers = ["John", "Alice", "Bob"]
    
    @Test("Sorts customers in ascending order")
    func testSortAscending() {
        let result = sorter.sort(customers, by: .ascending)
        #expect(result == ["Alice", "Bob", "John"])
    }
    
    @Test("Sorts customers in descending order")
    func testSortDescending() {
        let result = sorter.sort(customers, by: .descending)
        #expect(result == ["John", "Bob", "Alice"])
    }
    
    @Test("Returns empty array when input is empty")
    func testEmptyArray() {
        let result = sorter.sort([], by: .ascending)
        #expect(result.isEmpty)
    }
    
    @Test("Handles already sorted input correctly")
    func testAlreadySorted() {
        let result = sorter.sort(["A", "B", "C"], by: .ascending)
        #expect(result == ["A", "B", "C"])
    }
}


@Suite("String Extensions")
struct StringExtensionsTests {
    
    // MARK: - isEmptyOrWhitespace
    
    @Test("Empty string and whitespace-only are considered empty")
    func isEmptyOrWhitespace_basic() {
        #expect("".isEmptyOrWhitespace)
        #expect("   \n\t ".isEmptyOrWhitespace)
        #expect(!"a".isEmptyOrWhitespace)
        #expect(!" a ".isEmptyOrWhitespace)
    }
    
    // MARK: - isValidPassword (>= 10 chars after trimming)
    
    @Test("Password boundary at 9/10 characters")
    func isValidPassword_boundaries() {
        #expect(!"123456789".isValidPassword)   // 9
        #expect("1234567890".isValidPassword)   // 10
    }
    
    @Test("Password counts after trimming")
    func isValidPassword_trimming() {
        #expect("   1234567890   ".isValidPassword)   // 10 after trim
        #expect(!"   123456789   ".isValidPassword)   // 9 after trim
        #expect(!"".isValidPassword)
        #expect(!"        ".isValidPassword)
    }
    
    // MARK: - isEmail
    
    @Test("Valid emails (simple, subdomain, uppercase)")
    func isEmail_validSamples() {
        #expect("user@example.com".isEmail)
        #expect("user@mail.example.co.uk".isEmail)
        #expect("USER+tag@EXAMPLE.COM".isEmail)
    }
    
    @Test("Invalid emails (missing parts, bad dots, spaces)")
    func isEmail_invalidSamples() {
        #expect(!"user.example.com".isEmail)   // no @
        #expect(!"user@example".isEmail)      // no TLD
        #expect(!"user@example..com".isEmail) // double dot
        #expect(!" user@example.com".isEmail) // leading space
        #expect(!"user@example.com ".isEmail) // trailing space
        #expect(!"@example.com".isEmail)      // empty local
        #expect(!"user@.com".isEmail)         // empty domain label
        #expect(!"user@com".isEmail)          // no dot in domain
    }
}
