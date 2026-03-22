import SwiftUI

struct UserListScreen: View {
    @Environment(\.httpClient) private var httpClient
    @Environment(\.sort) private var sort

    @State private var loadingState: LoadingState = .loading
    @State private var sortOrder: SortOrder = .ascending
    @State private var sortedUsers: [User] = []

    private enum LoadingState {
        case loading
        case success([User])
        case failure(Error)
    }

    private func fetchUsers() async {
        do {
            let users = try await httpClient.fetchUsers()
            loadingState = .success(users)
        } catch {
            loadingState = .failure(error)
        }
    }

    private func applySort(users: [User], order: SortOrder) {
        sortedUsers = sort(users, by: \.name, order)
    }

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
                List(sortedUsers) { user in
                    Text(user.name)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(sortOrder == .ascending ? "Sort Descending" : "Sort Ascending") {
                            sortOrder = (sortOrder == .ascending) ? .descending : .ascending
                        }
                    }
                }
                .onAppear {
                    applySort(users: users, order: sortOrder)
                }
                .onChange(of: users) { _, newUsers in
                    applySort(users: newUsers, order: sortOrder)
                }
                .onChange(of: sortOrder) { _, newOrder in
                    applySort(users: users, order: newOrder)
                }
            }

        case .failure(let error):
            Text(error.localizedDescription)
        }
    }
}

#Preview {
    UserListScreen()
}
