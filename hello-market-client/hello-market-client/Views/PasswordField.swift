import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        HStack {
            if isPasswordVisible {
                TextField("Password", text: $password)
                    .textContentType(.password)
            } else {
                SecureField("Password", text: $password)
                    .textContentType(.password)
            }
            
            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    
    @Previewable @State var password: String = "password"
    PasswordField(password: $password)
}
