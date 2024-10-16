//
//  AddProductScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/14/24.
//

import SwiftUI
import PhotosUI

struct AddProductScreen: View {
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: Double?
    
    @Environment(\.showMessage) private var showMessage
    
    @Environment(\.dismiss) private var dismiss
    @Environment(ProductStore.self) private var productStore
    @AppStorage("userId") private var userId: Int?
    
    @Environment(\.uploader) private var uploader
    
    @State private var uiImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var isCameraSelected: Bool = false
    
    @State private var isLoading: Bool = false
    
    private var isFormValid: Bool {
        !name.isEmptyOrWhitespace && !description.isEmptyOrWhitespace
        && (price ?? 0) > 0
    }
    
    private func saveProduct() async {
        isLoading = true
        defer { isLoading = false } // Ensures loading state is turned off, even if an error occurs
        
        do {
            guard let uiImage = uiImage, let imageData = uiImage.pngData() else {
                throw ProductError.missingImage
            }
            
            guard let photoURL = try await uploader.upload(data: imageData) else {
                throw ProductError.uploadFailed
            }
            
            guard let userId = userId else {
                throw ProductError.missingUserId
            }
            
            guard let price = price else {
                throw ProductError.invalidPrice
            }
            
            let product = Product(name: name, description: description, price: price, photoUrl: photoURL, userId: userId)
            try await productStore.saveProduct(product)
            
            dismiss()
            
        } catch {
            showMessage("Failed to save product: \(error.localizedDescription)", .error)
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
        .onChange(of: selectedPhotoItem, {
            selectedPhotoItem?.loadTransferable(type: Data.self, completionHandler: { result in
                print(result)
                switch result {
                    case .success(let data):
                        if let data {
                            uiImage = UIImage(data: data)
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            })
        })
        .sheet(isPresented: $isCameraSelected, content: {
            ImagePicker(image: $uiImage, sourceType: .camera)
        })
        .buttonStyle(.bordered)
        .navigationTitle("Add Product")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await saveProduct()
                    }
                }.disabled(!isFormValid)
            }
        }.overlay(alignment: .center) {
            if isLoading {
                ProgressView("Loading...")
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddProductScreen()
    }
    .environment(ProductStore(httpClient: .development))
    .environment(\.uploader, Uploader(httpClient: .development))
    .withMessageView()
}
