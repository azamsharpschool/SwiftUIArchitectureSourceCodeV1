//
//  FormattingDemo.swift
//  ViewCompositionDemos
//
//  Created by Mohammad Azam on 10/22/25.
//

import SwiftUI

extension Locale {
    
    static var currencyCode: String {
        self.current.currency?.identifier ?? "USD"
    }
}

struct CompactNumberFormat: FormatStyle {
    func format(_ value: Double) -> String {
        switch value {
        case 1_000_000...:
            return String(format: "%.1fM", value / 1_000_000)
        case 1_000...:
            return String(format: "%.1fK", value / 1_000)
        default:
            return String(format: "%.0f", value)
        }
    }
}

extension FormatStyle where Self == CompactNumberFormat {
    static var compact: CompactNumberFormat { CompactNumberFormat() }
}

struct StarRatingFormat: FormatStyle {
    
    func format(_ value: Double) -> String {
        let fullStars = Int(value)
        let halfStar = value - Double(fullStars) >= 0.5
        return String(repeating: "★", count: fullStars) + (halfStar ? "☆" : "")
    }
}

extension FormatStyle where Self == StarRatingFormat {
    static var starRating: StarRatingFormat { StarRatingFormat() }
}

extension ButtonStyle where Self == ShadowButtonStyle {
    static var shadow: ShadowButtonStyle { ShadowButtonStyle() }
}

struct ShadowButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
                    .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
                    .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct FormattingDemo: View {
    
    // get the locale
    @Environment(\.locale) private var locale
    
    var body: some View {
        
        
        // USAGE
        Button("Button with Shadow") {
            
        }.buttonStyle(.shadow)
            
        
        
        // Basic number formatting
        Text(1234.5678, format: .number)
            
        // Limiting Decimal Places
        Text(1234.5678, format: .number.precision(.fractionLength(2)))
        
        Text(1234.5678, format: .number.precision(.fractionLength(0...2)))
        
        // Grouping Separators
        Text(1000000, format: .number.grouping(.automatic))
        
        // Rounding
        Text(1234.5678, format: .number.precision(.fractionLength(2)).rounded(rule: .down))
        
        // Percent
        Text(0.85, format: .percent)
        Text(0.80, format: .percent.precision(.fractionLength(0...2)))


        // Measurement Formatting
        Text(Measurement(value: 25, unit: UnitTemperature.celsius),
             format: .measurement(width: .narrow))
        
        VStack(alignment: .leading) {
            Text(Measurement(value: 1500, unit: UnitLength.meters),
                 format: .measurement(width: .narrow))       // 1.5 km
            Text(Measurement(value: 1500, unit: UnitLength.meters),
                 format: .measurement(width: .abbreviated))  // 1.5 km
            Text(Measurement(value: 1500, unit: UnitLength.meters),
                 format: .measurement(width: .wide))         // 1.5 kilometers
        }
        
        // Time Formatting
        Text(Duration.seconds(120), format: .time(pattern: .minuteSecond))

        VStack(alignment: .leading) {
            Text(Duration.seconds(65), format: .time(pattern: .minuteSecond))      // 1:05
            Text(Duration.seconds(3675), format: .time(pattern: .hourMinute))      // 1:01
            Text(Duration.seconds(3675), format: .time(pattern: .hourMinuteSecond)) // 1:01:15
        }

        // Custom Number Styles
        Text(CompactNumberFormat().format(12500))
        Text(12500, format: .compact)
        
        
        Text(4, format: .starRating) // -> ★★★★☆
       
        // Currency Formatting
        Text(45.54, format: .currency(code: locale.currency?.identifier ?? "USD"))
    }
}

#Preview {
    FormattingDemo()
}

#Preview("Currencies") {
    VStack(alignment: .leading, spacing: 16) {
        Group {
            Text("🇫🇷 Euro (France)")
            FormattingDemo()
                .environment(\.locale, Locale(identifier: "fr_FR"))
            
            Text("🇯🇵 Japanese Yen")
            FormattingDemo()
                .environment(\.locale, Locale(identifier: "ja_JP"))
            
            Text("🇲🇽 Mexican Peso")
            FormattingDemo()
                .environment(\.locale, Locale(identifier: "es_MX"))
            
            Text("🇵🇰 Pakistani Rupee")
            FormattingDemo()
                .environment(\.locale, Locale(identifier: "ur_PK"))
            
            Text("🇬🇧 British Pound")
            FormattingDemo()
                .environment(\.locale, Locale(identifier: "en_GB"))
        }
    }
    .padding()
    .font(.title3)
}


