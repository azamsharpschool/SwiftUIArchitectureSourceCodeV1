//
//  ContentView.swift
//  Movies
//
//  Created by Mohammad Azam on 1/3/26.
//

import SwiftUI
import Observation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        isEmpty || trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}

struct Movie: Codable, Identifiable {
    var id: UUID?
    let name: String
    let description: String
}

struct HTTPClient {
    
    func loadMovies() async throws -> [Movie] {
        // add a delay to mimic a network call
        try? await Task.sleep(for: .seconds(1.0))
        return [
            .init(id: UUID(), name: "Inception", description: "A thief steals secrets by entering dreams."),
            .init(id: UUID(), name: "The Matrix", description: "A hacker discovers reality is a simulation."),
            .init(id: UUID(), name: "Interstellar", description: "Explorers travel through a wormhole to save humanity."),
            .init(id: UUID(), name: "The Dark Knight", description: "Batman faces the Joker in Gotham."),
            .init(id: UUID(), name: "Parasite", description: "A poor family infiltrates a wealthy household.")
        ]
    }
    
    func createMovie(_ movie: Movie) async throws -> Movie? {
        try? await Task.sleep(for: .seconds(1.0))
        return Movie(id: UUID(), name: movie.name, description: movie.description)
    }
}

@Observable
class MovieListViewModel {
    
    var movies: [Movie] = []
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadMovies() async throws {
        movies = try await httpClient.loadMovies()
    }
}

struct AddMovieScreen: View {
    
    @Bindable var vm: AddMovieViewModel
    let onSave: (Movie) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            TextField("Title", text: $vm.name)
            TextField("Description", text: $vm.description)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    Task {
                        if let movie = try await vm.saveMovie() {
                            onSave(movie)
                            dismiss()
                        }
                    }
                }.disabled(!vm.isFormValid)
            }
        }
    }
}

@Observable
class AddMovieViewModel {
    
    let httpClient: HTTPClient
    
    var name: String = ""
    var description: String = ""
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    var isFormValid: Bool {
        !name.isEmptyOrWhitespace && !description.isEmptyOrWhitespace
    }
    
    func saveMovie() async throws -> Movie? {
        let movie = Movie(name: name, description: description)
        return try await httpClient.createMovie(movie)
    }
    
}

#Preview("AddMovieScreen") {
    NavigationStack {
        AddMovieScreen(vm: AddMovieViewModel(httpClient: HTTPClient())) { movie in
            
        }
    }
}

struct MovieListScreen: View {
    
    let vm: MovieListViewModel
    @State private var isPresented: Bool = false
    
    var body: some View {
        List(vm.movies) { movie in
            Text(movie.name)
        }.task {
            do {
                try await vm.loadMovies()
            } catch {
                print(error.localizedDescription)
            }
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Movie") {
                    isPresented = true
                }
            }
        }.sheet(isPresented: $isPresented) {
            NavigationStack {
                AddMovieScreen(vm: AddMovieViewModel(httpClient: vm.httpClient)) { movie in
                    vm.movies.append(movie)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieListScreen(vm: MovieListViewModel(httpClient: HTTPClient()))
    }
}
