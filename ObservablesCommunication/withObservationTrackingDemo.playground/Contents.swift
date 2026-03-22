import UIKit
import SwiftUI
import Observation

@Observable
class Dependent {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

@Observable
class User {
    let id: Int
    var name: String
    var dependents: [Dependent] = []
    
    init(id: Int, name: String, dependents: [Dependent] = []) {
        self.id = id
        self.name = name
        self.dependents = dependents
    }
}

//@Observable
class UserStore {
    
    var users: [User] = [
        User(id: 1, name: "Alice", dependents: [
            Dependent(id: 101, name: "Bob"),
            Dependent(id: 102, name: "Charlie")
        ]),
        User(id: 2, name: "David"),
        User(id: 3, name: "Emma", dependents: [
            Dependent(id: 103, name: "Sophia")
        ])
    ]
    
    func addDependent(_ dependent: Dependent, to userId: Int) {
        
        guard let index = users.firstIndex(where: { $0.id == userId })
        else {
            return
        }
        
        users[index].dependents.append(dependent)
    }
}

enum UserError: Error {
    case notFound
}

@MainActor
//@Observable
class InsuranceStore {
    
    let userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }
    
    func startTracking(for userId: Int) throws {
        
        guard let index = userStore.users.firstIndex(where: { $0.id == userId }) else {
            throw UserError.notFound
        }

        withObservationTracking {
            print("apply")
            // what properties to track
            let _ = userStore.users[index].dependents.count
            
        } onChange: { [weak self] in
            Task { @MainActor in
                guard let self else { return }
                await self.calculateInsurance()
                try self.startTracking(for: userId)
            }
        }
        
    }
    
    private func calculateInsurance() async {
        print("Calculating Insurance...")
    }
}

let userStore = UserStore()
let user = userStore.users[0]
let insuranceStore = InsuranceStore(userStore: userStore)
try insuranceStore.startTracking(for: 1)


// now change the user and add dependent
user.dependents.append(Dependent(id: 1, name: "name of dependent"))

