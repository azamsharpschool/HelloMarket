//
//  MyProductListScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/13/24.
//

import SwiftUI

struct MyProductListScreen: View {
    
    @Environment(\.showMessage) private var showMessage
    @Environment(ProductStore.self) private var productStore
    @State private var isPresented: Bool = false
    
    private func loadMyProducts() async {
        
        do {
            try await productStore.loadMyProducts()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        List(productStore.myProducts) { product in
            NavigationLink {
                MyProductDetailScreen(product: product)
            } label: {
                MyProductCellView(product: product)
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .task {
           await loadMyProducts()
        }.navigationTitle("My Products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Product") {
                        isPresented = true
                    }
                }
        }
        .sheet(isPresented: $isPresented, content: {
            NavigationStack {
                AddProductScreen()
                    .withMessageView()
            }
        })
        .overlay(alignment: .center) {
            if productStore.myProducts.isEmpty {
                ContentUnavailableView("No products available.", systemImage: "cart")
            }
        }
    }
}

struct MyProductCellView: View {
    
    let product: Product
    
    var body: some View {
        
        HStack(alignment: .top) {
                AsyncImage(url: product.photoUrl) { img in
                    img.resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView("Loading...")
                }
                Spacer()
                    .frame(width: 20)
                VStack {
                    Text(product.name)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(product.price, format: .currency(code: "USD"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
        }
    }
}

#Preview {
    NavigationStack {
        MyProductListScreen()
    }.environment(ProductStore(httpClient: .development))
}
