import Foundation
import SwiftUI

struct User: Identifiable, Equatable {
    let id: UUID
    let name: String
}

enum SortOrder {
    case ascending
    case descending
}

struct Sorter {
    func callAsFunction<T, V: Comparable>(_ values: [T], by keyPath: KeyPath<T, V>, _ order: SortOrder) -> [T] {
        switch order {
        case .ascending:
            return values.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        case .descending:
            return values.sorted { $0[keyPath: keyPath] > $1[keyPath: keyPath] }
        }
    }
}

protocol HttpClient {
    func fetchUsers() async throws -> [User]
}

struct MockHttpClient: HttpClient {
    func fetchUsers() async throws -> [User] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return [
            User(id: UUID(), name: "Ava"),
            User(id: UUID(), name: "Noah"),
            User(id: UUID(), name: "Sophia"),
            User(id: UUID(), name: "Liam")
        ]
    }
}

private struct HttpClientKey: EnvironmentKey {
    static let defaultValue: HttpClient = MockHttpClient()
}

private struct SorterKey: EnvironmentKey {
    static let defaultValue = Sorter()
}

extension EnvironmentValues {
    var httpClient: HttpClient {
        get { self[HttpClientKey.self] }
        set { self[HttpClientKey.self] = newValue }
    }

    var sort: Sorter {
        get { self[SorterKey.self] }
        set { self[SorterKey.self] = newValue }
    }
}
