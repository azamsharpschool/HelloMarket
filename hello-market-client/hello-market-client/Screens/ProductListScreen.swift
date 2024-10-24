//
//  ProductListScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/11/24.
//

import SwiftUI

struct ProductListScreen: View {
    
    @Environment(ProductStore.self) private var productStore
    
    private func loadAllProducts() async {
        do {
            try await productStore.loadAllProducts()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        List(productStore.products) { product in
          
            ZStack {
                ProductCellView(product: product)
                
                NavigationLink(destination: ProductDetailScreen(product: product)) {
                    EmptyView()
                }
                
            }.listRowSeparator(.hidden)
        }
        .refreshable(action: {
            await loadAllProducts()
        })
        .navigationTitle("New Arrivals")
        .listStyle(.plain)
        .task {
           await loadAllProducts()
        }
    }
}

struct ProductCellView: View {
      
    let product: Product
     
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: product.photoUrl) { img in
                img.resizable()
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .scaledToFit()
            } placeholder: {
                ProgressView("Loading...")
            }
            Text(product.name)
                .font(.title)
            Text(product.price, format: .currency(code: "USD"))
                .font(.title2)
        }
    }
}

#Preview {
    NavigationStack {
        ProductListScreen()
    } .environment(ProductStore(httpClient: .development))
}
