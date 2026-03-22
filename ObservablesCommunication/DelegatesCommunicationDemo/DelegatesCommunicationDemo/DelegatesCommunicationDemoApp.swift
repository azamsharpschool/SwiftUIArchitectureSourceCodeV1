//
//  DelegatesCommunicationDemoApp.swift
//  DelegatesCommunicationDemo
//
//  Created by Mohammad Azam on 1/21/26.
//

import SwiftUI

@main
struct DelegatesCommunicationDemoApp: App {
    
    @State private var userStore: UserStore
    @State private var insuranceStore: InsuranceStore

    
    init() {
        let http = HTTPClient()
        let userStore = UserStore(httpClient: http)
        let insurance = InsuranceStore(httpClient: http)
        userStore.delegate = insurance   // wire them here
        _userStore = State(initialValue: userStore)
        _insuranceStore = State(initialValue: insurance)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .environment(userStore)
            .environment(insuranceStore)
        }
    }
}
