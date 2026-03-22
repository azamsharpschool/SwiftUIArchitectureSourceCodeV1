//
//  ContentView.swift
//  DemoNavigation
//
//  Created by Mohammad Azam on 1/29/26.
//

import SwiftUI

struct Product: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
}

struct ContentView: View {
    
    let products: [Product] = [
        Product(name: "iPhone"),
        Product(name: "MacBook Pro"),
        Product(name: "iPad Air"),
        Product(name: "Apple Watch"),
        Product(name: "AirPods Pro"),
        Product(name: "HomePod Mini")
    ]
    
    var body: some View {
       ProductListView(products: products)
            .navigationDestination(for: Product.self) { product in
                ProductDetailScreen(product: product)
            }
    }
}

struct ProductDetailScreen: View {
    let product: Product
    
    var body: some View {
        Text(product.name)
            .font(.largeTitle)
    }
}

struct ProductListView: View {
    
    let products: [Product]
    
    var body: some View {
        List(products) { product in
            NavigationLink(value: product) {
                ProductView(product: product)
            }
        }
    }
}

struct ProductView: View {
    
    let product: Product
    
    var body: some View {
        Text(product.name)
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}



