//
//  TabViewHome.swift
//  Platzi
//
//  Created by Mohammad Azam on 9/24/25.
//

import SwiftUI

struct OrderingScreen: View {
    var body: some View {
        Text("Ordering Screen")
    }
}

struct ShippingScreen: View {
    var body: some View {
        Text("Shipping Screen")
    }
}

struct TabViewHome: View {
    
    @State private var orderingStore = OrderingStore()
    @State private var shippingStore = ShippingStore()
    
    var body: some View {
        TabView {
            Tab("Orders", systemImage: "house") {
                OrderingScreen()
                    .environment(orderingStore)
            }
            Tab("Shipping", systemImage: "heart") {
                ShippingScreen()
                    .environment(shippingStore)
            }
        }
    }
}

#Preview {
    TabViewHome()
}
