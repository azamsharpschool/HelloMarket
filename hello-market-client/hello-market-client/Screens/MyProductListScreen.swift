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
    @AppStorage("userId") private var userId: Int?
    
    private func loadMyProducts() async {
        
        guard let userId = userId else {
            showMessage("User ID is missing.", .error)
            return
        }
        
        do {
            try await productStore.loadMyProducts(by: userId)
        } catch {
            showMessage("Unable to load products: \(error.localizedDescription)", .error)
        }
    }
    
    var body: some View {
        List(productStore.myProducts) { product in
            MyProductCellView(product: product)
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
