import Foundation

struct Product: Identifiable, Decodable {
    let id: Int
    let name: String
    let category: String
    let price: Double
}
