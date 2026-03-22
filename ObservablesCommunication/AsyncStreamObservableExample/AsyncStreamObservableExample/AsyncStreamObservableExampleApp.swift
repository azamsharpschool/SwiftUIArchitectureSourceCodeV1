//
//  AsyncStreamObservableExampleApp.swift
//  AsyncStreamObservableExample
//
//  Created by Mohammad Azam on 1/8/26.
//

import SwiftUI

@main
struct AsyncStreamDemoApp: App {

    @State private var userStore: UserStore
    @State private var insuranceStore: InsuranceStore
    @State private var documentStore: DocumentStore

    init() {
        let user = UserStore()
        let insurance = InsuranceStore()
        let docs = DocumentStore()

        // Seed initial user
        let userId = UUID()
        user.users = [User(id: userId)]

        // Wire listeners once
        insurance.startListening(to: user.events())
        docs.startListening(to: user.events())

        _userStore = State(initialValue: user)
        _insuranceStore = State(initialValue: insurance)
        _documentStore = State(initialValue: docs)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userStore)
                .environment(insuranceStore)
                .environment(documentStore)
        }
    }
}
