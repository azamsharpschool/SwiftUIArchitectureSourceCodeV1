//
//  ContentView.swift
//  CachingResponses
//
//  Created by Mohammad Azam on 2/11/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MovieListScreen()
                .tabItem {
                    Label("Movies", systemImage: "film")
                }

            ProductListScreen()
                .tabItem {
                    Label("Products", systemImage: "cart")
                }
        }
    }
}

#Preview {
    ContentView()
}


