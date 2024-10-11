//
//  MyProductListScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/13/24.
//

import SwiftUI

struct MyProductListScreen: View {
    
    @Environment(ProductStore.self) private var productStore
    @State private var isPresented: Bool = false
    
    var body: some View {
        List(productStore.myProducts) { product in
            ProductCellView(product: product)
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .task {
            do {
                try await productStore.loadMyProducts(by: 1)
            } catch {
                print(error)
            }
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
            }
        })
    }
}

#Preview {
    NavigationStack {
        MyProductListScreen()
    }.environment(ProductStore(httpClient: .development))
}
