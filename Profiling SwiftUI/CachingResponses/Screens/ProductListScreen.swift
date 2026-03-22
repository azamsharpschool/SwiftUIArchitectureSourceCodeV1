import SwiftUI

struct ProductListScreen: View {
    @State private var products: [Product] = []
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading Products...")
                } else if let errorMessage {
                    ContentUnavailableView("Unable to Load Products", systemImage: "exclamationmark.triangle", description: Text(errorMessage))
                } else {
                    List(products) { product in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(product.name)
                                .font(.headline)
                            Text(product.category)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(product.price, format: .currency(code: "USD"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Products")
            .task {
                await loadProducts()
            }
            .refreshable {
                await loadProducts()
            }
        }
    }

    private func loadProducts() async {
        guard let url = URL(string: "http://localhost:8080/api/products") else {
            errorMessage = "Invalid URL."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            products = try JSONDecoder().decode([Product].self, from: data)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    ProductListScreen()
}
