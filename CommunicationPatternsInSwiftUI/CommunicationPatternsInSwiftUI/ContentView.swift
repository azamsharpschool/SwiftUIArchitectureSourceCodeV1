//
//  ContentView.swift
//  CommunicationPatternsInSwiftUI
//
//  Created by Mohammad Azam on 9/3/25.
//

import SwiftUI

struct User: Identifiable {
    let id = UUID()
    let name: String
}

struct HTTPClient {
    
    func fetchUsers() async throws -> [User] {
        return [
            .init(name: "User 1"),
            .init(name: "User 2"),
        ]
    }
}

extension EnvironmentValues {
    @Entry var httpClient = HTTPClient()
}

/*
struct AddUserScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    
    @Binding var users: [User]
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            Button("Save") {
                let user = User(name: name)
                users.append(user)
                dismiss()
            }
        }
    }
} */

/*
struct UserListScreen: View {
    
    @Environment(\.httpClient) private var httpClient
    
    @State private var users: [User] = []
    @State private var isPresented: Bool = false
    
    private func handleUserAdd(user: User) {
        users.append(user)
    }
    
    var body: some View {
        List(users) { user in
            Text(user.name)
        }
        .sheet(isPresented: $isPresented, content: {
            AddUserScreen(users: $users)
        })
        .task {
            // fetch the users
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add New User") {
                    isPresented = true
                }
            }
        })
       
        .navigationTitle("Users")
    }
} */

@Observable
class UserStore {
    
    // make HTTPClient protocol if needed
    let httpClient: HTTPClient
    private(set) var users: [User] = []
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
        self.users = users
    }
    
    func addUser(_ user: User) {
        users.append(user)
    }
    
    func loadUsers() async throws {
        do {
            users = try await httpClient.fetchUsers()
        } catch {
            print(error)
        }
    }
}

/*
struct AddUserScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    let onUserAdd: (User) -> Void
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            Button("Save") {
                let user = User(name: name)
                onUserAdd(user)
                dismiss()
            }
        }
    }
} */

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        UserListScreen()
    }
    .environment(UserStore(httpClient: HTTPClient()))
}

struct UserListScreen: View {
    
    @Environment(UserStore.self) private var userStore
    @State private var isPresented: Bool = false
    
    var body: some View {
        List(userStore.users) { user in
            Text(user.name)
        }
        .sheet(isPresented: $isPresented, content: {
            //AddUserScreen()
        })
        .task {
            do {
                try await userStore.loadUsers()
            } catch {
                print(error)
            }
        }
       
        .navigationTitle("Users")
    }
}

struct AddUserScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @Environment(UserStore.self) private var userStore
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            Button("Save") {
                let user = User(name: name)
                userStore.addUser(user)
                dismiss()
            }
        }
    }
}

#Preview {
    ContentView()
}
