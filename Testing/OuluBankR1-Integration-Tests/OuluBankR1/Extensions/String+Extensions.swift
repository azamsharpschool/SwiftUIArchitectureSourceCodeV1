import Foundation

extension String {
    
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isSSN: Bool {
        // Define the SSN regex pattern
        let ssnPattern = #"^(?!000|666|9\d{2})\d{3}-(?!00)\d{2}-(?!0000)\d{4}$"#
        
        // Create a regex object
        guard let regex = try? NSRegularExpression(pattern: ssnPattern) else {
            return false
        }
        
        // Check if the string matches the regex pattern exactly
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)
        
        // Ensure the entire string matches the pattern (no extra characters)
        return matches.count == 1 && matches[0].range == range
    }
    
}
