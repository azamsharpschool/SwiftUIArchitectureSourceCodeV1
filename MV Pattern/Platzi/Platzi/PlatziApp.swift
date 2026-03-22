//
//  PlatziApp.swift
//  Platzi
//
//  Created by Mohammad Azam on 9/14/25.
//

import SwiftUI

@main
struct PlatziApp: App {
    
    @State private var orderingStore = OrderingStore()
    @State private var shippingStore = ShippingStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .environment(orderingStore)
            .environment(shippingStore)
        }
    }
}
