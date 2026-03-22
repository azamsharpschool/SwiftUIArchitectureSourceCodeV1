import Foundation

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let year: Int
    let rating: Double
}
