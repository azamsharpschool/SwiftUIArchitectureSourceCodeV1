//
//  ContentView.swift
//  ContainerPresenterDemo
//
//  Created by Mohammad Azam on 9/3/25.
//

import SwiftUI

struct User: Identifiable, Decodable {
    let id: Int
    let name: String
}

struct HTTPClient {
    
    func fetchPosts() async throws -> [User] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/users")!)
        return try JSONDecoder().decode([User].self, from: data)
    }
}

extension EnvironmentValues {
    @Entry var httpClient = HTTPClient()
}

enum SortOrder {
    case ascending
    case descending
}

struct SortAction {
    
    var sortOrder: SortOrder = .ascending
    
    func callAsFunction<T: Comparable, U>(_ array: [U], by keyPath: KeyPath<U, T>, _ order: SortOrder = .ascending) -> [U] {
        switch order {
        case .ascending:
            return array.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        case .descending:
            return array.sorted { $0[keyPath: keyPath] > $1[keyPath: keyPath] }
        }
    }
}

extension EnvironmentValues {
    @Entry var sort = SortAction()
}

struct ContentView: View {
    
    @Environment(\.httpClient) private var httpClient
    @Environment(\.sort) private var sort
    @State private var loadingState: LoadingState = .loading
    @State private var sortOrder: SortOrder = .ascending
    
    private enum LoadingState {
        case loading
        case success([User])
        case failure(Error)
    }
    
    private func fetchUsers() async {
        do {
            let users = try await httpClient.fetchPosts()
            loadingState = .success(users)
        } catch {
            loadingState = .failure(error)
        }
    }
    
    /*
    private func sortUsers(_ users: [User]) -> [User] {
        switch sortOrder {
        case .ascending:
            return users.sorted { $0.name < $1.name }
        case .descending:
            return users.sorted { $0.name > $1.name }
        }
    } */
    
    var body: some View {
        
        switch loadingState {
            case .loading:
                ProgressView("Loading...")
                .task {
                    await fetchUsers()
                }
            case .success(let users):
            if users.isEmpty {
                ContentUnavailableView("No users found.", systemImage: "heart")
            } else {
                List(sort(users, by: \.name, sortOrder)) { user in
                    Text(user.name)
                }.toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(sortOrder == .ascending ? "Sort Descending" : "Sort Ascending") {
                            sortOrder = (sortOrder == .ascending) ? .descending : .ascending
                        }
                    }
                }
            }
               
            case .failure(let error):
                Text(error.localizedDescription)
        }

    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
