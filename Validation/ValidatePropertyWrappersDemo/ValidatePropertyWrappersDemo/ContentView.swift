//
//  ContentView.swift
//  ValidationDemo
//
//  Created by Mohammad Azam on 3/24/25.
//

import SwiftUI

// Validation View Modifier
struct ValidationModifier: ViewModifier {
    
    let errorMessage: String?
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            content
            
            Text(errorMessage ?? "")
                .font(.caption)       // Smaller text for error message
                .foregroundColor(.red)
                .frame(height: 20)    // Keep consistent height
                .opacity(errorMessage == nil ? 0 : 1)  // Hide when no error
                .animation(.easeInOut(duration: 0.2), value: errorMessage) // Smooth transition
        }
    }
}

extension View {
    func withValidation(_ errorMessage: String?) -> some View {
        self.modifier(ValidationModifier(errorMessage: errorMessage))
    }
}




enum RegexExpression: String {
    case email = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
}

enum ValidationRule {
    case required(String)
    case regularExpression(RegexExpression, String)
}

@propertyWrapper
struct Validate<T: Equatable> {
    
    private var value: T
    private var initialValue: T
    private var rules: [ValidationRule]
    private var isDirty = false
    
    var wrappedValue: T {
        get { value }
        set {
            
            if newValue != initialValue {
                isDirty = true
            }
            
            value = newValue
        }
    }
    
    var projectedValue: String? {
        
        guard isDirty else { return nil }
        
        for rule in rules {
            if let message = validate(rule: rule) {
                return message
            }
        }
        
        return nil
    }
    
    private func validate(rule: ValidationRule) -> String? {
        
        switch rule {
            case .required(let message):
                return validateRequired(message: message)
            case .regularExpression(let regexExpression, let message):
                return validateRegex(pattern: regexExpression.rawValue, message: message)
        }
    }
    
    private func validateRequired(message: String) -> String? {
        
        if let stringValue = value as? String, stringValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return message
        }
        
        return nil
    }
    
    private func validateRegex(pattern: String, message: String) -> String? {
        guard let stringValue = value as? String else { return nil }
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: stringValue.utf16.count)
        
        return regex?.firstMatch(in: stringValue, options: [], range: range) == nil ? message : nil
    }
    
    init(wrappedValue: T, _ rules: ValidationRule...) {
        self.value = wrappedValue
        self.initialValue = wrappedValue
        self.rules = rules
    }
    
}

struct Customer {
    
    @Validate(
        .required("Email is required."),
        .regularExpression(.email, "Email should be in correct format.")
    )
    var email: String = ""
    
}

struct ContentView: View {
    
    @State private var customer = Customer()
    
    var body: some View {
        VStack {
            TextField("Email", text: $customer.email)
                .textFieldStyle(.roundedBorder)
                .withValidation(customer.$email)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
