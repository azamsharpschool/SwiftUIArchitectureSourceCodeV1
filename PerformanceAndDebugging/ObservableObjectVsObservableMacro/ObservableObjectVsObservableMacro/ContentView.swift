//
//  ContentView.swift
//  ObservableObjectVsObservableMacro
//
//  Created by Mohammad Azam on 11/2/25.
//

import SwiftUI
import Combine
import Observation


class UserStore1: ObservableObject {
    @Published var name: String = ""
    @Published var age: Int = 0
}

@Observable
class UserStore {
    var name: String = ""
    var age: Int = 0
}

struct UserNameView: View {
    
    let userStore: UserStore
    
    var body: some View {
        let _ = Self._printChanges() // Logs reevaluation
        VStack {
            Text("User Name View")
            Text(userStore.name)
        }.padding()
    }
}

struct UserAgeView: View {
    
    let userStore: UserStore
    
    var body: some View {
        let _ = Self._printChanges() // Logs reevaluation
        VStack {
            Text("User Age View")
            Text("\(userStore.age)")
        }.padding()
    }
}

struct ContentView: View {
    
    @State private var userStore = UserStore()

    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Enter Name", text: $userStore.name)
                .textFieldStyle(.roundedBorder)
                .padding()

            Stepper("Age: \(userStore.age)", value: $userStore.age)
                .padding()

            UserNameView(userStore: userStore)
            UserAgeView(userStore: userStore)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
