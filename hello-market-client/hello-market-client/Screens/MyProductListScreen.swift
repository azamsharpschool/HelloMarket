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
            MyProductCellView(product: product)
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .task {
            do {
                try await productStore.loadMyProducts(by: 2)
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
                        .font(.title)
                    Text(product.price, format: .currency(code: "USD"))
                        
                }
               
            }
    }
}

#Preview {
    NavigationStack {
        MyProductListScreen()
    }.environment(ProductStore(httpClient: .development))
}
