import SwiftUI

struct MovieListScreen: View {
    @State private var movies: [Movie] = []
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {  
                    ProgressView("Loading Movies...")
                } else if let errorMessage {
                    ContentUnavailableView("Unable to Load Movies", systemImage: "exclamationmark.triangle", description: Text(errorMessage))
                } else {
                    List(movies) { movie in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(movie.title)
                                .font(.headline)
                            Text("Year: \(movie.year)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Rating: \(movie.rating, specifier: "%.1f")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Movies")
            .task {
                await loadMovies()
            }
            .refreshable {
                await loadMovies()
            }
        }
    }

    private func loadMovies() async {
        guard let url = URL(string: "http://localhost:8080/api/movies") else {
            errorMessage = "Invalid URL."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            movies = try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    MovieListScreen()
}
