//
//  ProductDetailScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/13/24.
//

import SwiftUI

struct ProductDetailScreen: View {
    
    let product: Product
    
    var body: some View {
        ScrollView {
            AsyncImage(url: product.photoUrl) { img in
                img.resizable()
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .scaledToFit()
            } placeholder: {
                ProgressView("Loading...")
            }
            
            Text(product.name)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(product.description)
                .padding([.top], 5)
            Text(product.price, format: .currency(code: "USD"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
                .padding([.top], 2)
            
            Button {
                    
                } label: {
                    Text("Add to cart")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(25)
                }
               
            
        }.padding()
    }
}

#Preview {
    ProductDetailScreen(product: Product.preview)
}
