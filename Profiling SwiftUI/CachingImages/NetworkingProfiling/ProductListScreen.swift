//
//  ProductListScreen.swift
//  NetworkingProfiling
//
//  Created by Mohammad Azam on 2/10/26.
//

import Kingfisher
import SwiftUI

struct ProductListScreen: View {
    @State private var products: [Product] = []

    var body: some View {
        List(products) { product in
            HStack(alignment: .top, spacing: 12) {
                if let imageUrl = product.images.first {
                    KFImage(imageUrl)
                        .placeholder {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    Image(systemName: "photo")
                        .frame(width: 60, height: 60)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(product.title)
                        .font(.headline)
                    Text("$\(product.price)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(product.description)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                    Text("Category: \(product.category.name)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Products")
        .task {
            await loadProducts()
        }
    }

    private func loadProducts() async {
        guard let url = URL(string: "https://api.escuelajs.co/api/v1/products") else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
            await MainActor.run {
                products = decodedProducts
            }
        } catch {
            // Intentionally ignoring errors for the profiling demo.
        }
    }
}

#Preview {
    NavigationStack {
        ProductListScreen()
    }
}

private struct Product: Identifiable, Decodable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let images: [URL]
    let category: ProductCategory
}

private struct ProductCategory: Decodable {
    let name: String
}
