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
    
    //let onMovieAdded: (Movie) -> Void
    //let onMovieDelete: (Movie) -> Void
    //let onSelectMovie: (Movie) -> Void

    let onEvent: (Event) -> Void
    @Environment(\.dismiss) private var dismiss
    
    enum Event {
        case addMovie(Movie)
        case deleteMovie(Movie)
        case selectMovie(Movie)
    }
    
    var body: some View {
        VStack {
            Button("Add Movie") {
                let movie = Movie(name: "Lord of the Rings")
                onEvent(.addMovie(movie))
                dismiss()
            }
            
            Button("Delete Movie") {
                let movieToBeDeleted = Movie(name: "Lord of the Rings")
                onEvent(.deleteMovie(movieToBeDeleted))
                dismiss()
            }
            
            Button("Select Movie") {
                let selectedMovie = Movie(name: "Lord of the Rings")
                onEvent(.selectMovie(selectedMovie))
                dismiss()
            }
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
            AddMovieScreen { event in
                switch event {
                    case .addMovie(let movie):
                        print(movie.name)
                    case .deleteMovie(let movie):
                        print("deleted")
                        print(movie.name)
                    case .selectMovie(let movie):
                        print("selected")
                        print(movie.name)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieListScreen()
    }
}
