//
//  AddProductScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/14/24.
//

import SwiftUI
import PhotosUI

struct AddProductScreen: View {
    
    let product: Product?
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: Double?
    
    @Environment(\.showMessage) private var showMessage
    
    @Environment(\.dismiss) private var dismiss
    @Environment(ProductStore.self) private var productStore
    @AppStorage("userId") private var userId: Int?
    
    @Environment(\.uploaderDownloader) private var uploaderDownloader
    
    @State private var uiImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var isCameraSelected: Bool = false
    
    @State private var isLoading: Bool = false
    
    init(product: Product? = nil) {
        self.product = product
    }
    
    private var isFormValid: Bool {
        !name.isEmptyOrWhitespace && !description.isEmptyOrWhitespace
        && (price ?? 0) > 0
    }
    
    private var actionTitle: String {
        product != nil ? "Update Product": "Add Product"
    }
    
    private func saveOrUpdateProduct() async {
        isLoading = true
        defer { isLoading = false } // Ensures loading state is turned off, even if an error occurs
        
        do {
            guard let uiImage = uiImage, let imageData = uiImage.pngData() else {
                throw ProductError.missingImage
            }
            
            guard let photoURL = try await uploaderDownloader.upload(data: imageData) else {
                throw ProductError.uploadFailed
            }
            
            guard let userId = userId else {
                throw ProductError.missingUserId
            }
            
            guard let price = price, price > 0 else {
                throw ProductError.invalidPrice
            }
            
            let product = Product(id: self.product?.id, name: name, description: description, price: price, photoUrl: photoURL, userId: userId)
            
            if self.product != nil {
                try await productStore.updateProduct(product)
            } else {
                try await productStore.saveProduct(product)
            }
            
            dismiss()
            
        } catch {
            showMessage("Error saving product: \(error.localizedDescription)")
        }
    }
    
    
    var body: some View {
        
        Form {
            TextField("Enter name", text: $name)
            TextEditor(text: $description)
                .frame(height: 100)
            TextField("Enter price", value: $price, format: .number)
            
            HStack {
                Button(action: {
                    
                    if UIImagePickerController.isSourceTypeAvailable( .camera) {
                        isCameraSelected = true
                    } else {
                        // show message
                        showMessage("Camera is not supported on this device.")
                    }
                }, label: {
                    Image(systemName: "camera.fill")
                })
                Spacer().frame(width: 20)
                
                PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "photo.on.rectangle")
                }
                
            }.font(.title)
            
            
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

        }
        .task(id: selectedPhotoItem, {
            if let selectedPhotoItem {
                do {
                    if let data = try await selectedPhotoItem.loadTransferable(type: Data.self) {
                        uiImage = UIImage(data: data)
                    }
                } catch {
                    showMessage("Unable to select an image!")
                }
            }
        })
        .sheet(isPresented: $isCameraSelected, content: {
            ImagePicker(image: $uiImage, sourceType: .camera)
        })
        
        .buttonStyle(.bordered)
        .navigationTitle(actionTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(actionTitle) {
                    Task {
                        await saveOrUpdateProduct()
                    }
                }.disabled(!isFormValid)
            }
        }.overlay(alignment: .center) {
            if isLoading {
                ProgressView("Loading...")
            }
        }
        .task {
            do {
                
                guard let product = product else { return }
                
                name = product.name
                description = product.description
                price = product.price
                
                if let photoUrl = product.photoUrl {
                    guard let data = try await uploaderDownloader.download(from: photoUrl) else {
                        return
                    }
                    
                    uiImage = UIImage(data: data)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddProductScreen(product: Product.preview)
    }
    .environment(ProductStore(httpClient: .development))
    .environment(\.uploaderDownloader, ImageUploaderDownloader(httpClient: .development))
    .withMessageView()
}
