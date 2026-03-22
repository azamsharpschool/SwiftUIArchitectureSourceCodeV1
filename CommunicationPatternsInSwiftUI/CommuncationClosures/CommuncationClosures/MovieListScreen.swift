//
//  ContentView.swift
//  CommuncationClosures
//
//  Created by Mohammad Azam on 9/6/25.
//

import SwiftUI

struct Movie: Identifiable {
    let id = UUID()
    let name: String
}

struct AddMovieScreen: View {
    
    let onMovieAdded: (Movie) -> Void
    let onMovieDelete: (Movie) -> Void
    let onSelectMovie: (Movie) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button("Add Movie") {
            let movie = Movie(name: "Lord of the Rings")
            onMovieAdded(movie)
            dismiss()
        }
    }
}

struct MovieListScreen: View {
    
    @State private var isPresented: Bool = false
    @State private var movies: [Movie] = [
        Movie(name: "Inception"),
        Movie(name: "The Dark Knight"),
        Movie(name: "Interstellar"),
        Movie(name: "The Matrix"),
        Movie(name: "Fight Club")
    ]
    
    var body: some View {
        List(movies) { movie in
            Text(movie.name)
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Movie") {
                    isPresented = true
                }
            }
        }.sheet(isPresented: $isPresented) {
            AddMovieScreen(onMovieAdded: { movie in
            }, onMovieDelete: { movie in
            }, onSelectMovie: { movie in
            })
        }
    }
}

#Preview {
    NavigationStack {
        MovieListScreen()
    }
}
