import SwiftUI
import shared

struct KeychainView: View {
    @State private var service: String = "com.nedap.healthcare.milo.shared"
    @State private var accessGroup: String = "" //"3RDHV33898.com.nedap.healthcare.milo.shared"
    @State private var keyName: String = ""
    @State private var keyValue: String = ""
    @State private var storedValue: String = ""
    @State private var showMessage: Bool = false
    @State private var message: String = ""
    @State private var showJsonView: Bool = false
    @State private var allKeysValues: [(key: String, value: String)] = []
    @State private var keyboardHeight: CGFloat = 0
    
    private var keychain: Keychain {
        let keychain = Keychain(
            service: service,
            accessGroup: accessGroup.isEmpty ? nil : accessGroup,
            accessibility: .afterFirstUnlock,
            decoderClasses: [NSString.self]
            )
        return keychain
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Configuration Section
                    GroupBox(label: Text("KeychainSwift Configuration").bold()) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Service")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Button("milo.shared") {
                                    service = "com.nedap.healthcare.milo.shared"
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                                
                                Button("❌") {
                                    service = ""
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(8)
                            }
                            
                            TextField("", text: $service)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            HStack {
                                Text("Access Group")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Button("milo.shared") {
                                    accessGroup = "3RDHV33898.com.nedap.healthcare.milo.shared"
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                                
                                Button("❌") {
                                    accessGroup = ""
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(8)
                            }
                            
                            TextField("", text: $accessGroup)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Retrieved Value Section
                    GroupBox(label: Text("Retrieved Value").bold()) {
                        if storedValue.isEmpty {
                            Text("No value retrieved yet. Use the Fetch button to retrieve a value.")
                                .foregroundColor(.gray)
                                .italic()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 10)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Key: \(keyName)")
                                    .font(.headline)
                                
                                Divider()
                                
                                ScrollView {
                                    Text(storedValue)
                                        .padding(8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(UIColor.systemBackground).opacity(0.8))
                                        .cornerRadius(4)
                                        .textSelection(.enabled)
                                }
                                .frame(maxHeight: 200)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    // Key Management Section
                    GroupBox(label:
                                HStack(spacing: 8.0) {
                        Text("Key Management").bold()
//                        Button("Clear") {
//                            let keychain = getKeychain()
//                            clearValues()
//                        }
//                        .font(.caption)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 6)
//                        .background(Color.red.opacity(0.1))
//                        .foregroundColor(.red)
//                        .cornerRadius(8)
                    }
                                
                    ) {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            HStack(spacing: 8) {
                                Text("Key Name")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Button("test") {
                                    keyName = "test"
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                                
                                Button("Milo token") {
                                    keyName = "access_token"
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                                
                                Button("JWT token") {
                                    keyName = "token_data_key"
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                            }
                            .padding(.bottom, 4)
                            
                            TextField("", text: $keyName)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("Key Value")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            TextField("", text: $keyValue)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 12)
                            
                            HStack(spacing: 10) {
                                Button(action: { fetchValue() }) {
                                    Text("Fetch")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                                .disabled(keyName.isEmpty)
                                
                                Button(action: { saveValue() }) {
                                    Text("Save")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue)
                                .disabled(keyName.isEmpty || keyValue.isEmpty)
                                
                                Button(action: { deleteValue() }) {
                                    Text("Delete")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red)
                                .disabled(keyName.isEmpty)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Add padding at the bottom for keyboard
                    Spacer().frame(height: keyboardHeight)
                }
                .padding()
            }
            .navigationTitle("Keychain Manager")
            .alert(isPresented: $showMessage) {
                Alert(
                    title: Text("Keychain Operation"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $showJsonView) {
                NavigationView {
                    List {
                        ForEach(allKeysValues, id: \.key) { keyValue in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(keyValue.key)
                                    .font(.headline)
                                
                                Text(keyValue.value)
                                    .font(.body)
                                    .textSelection(.enabled)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .navigationTitle("KMP Auth Tokens")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Close") {
                                showJsonView = false
                            }
                        }
                    }
                }
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                        keyboardHeight = keyboardSize.height
                    }
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    keyboardHeight = 0
                }
            }
        }
    }
}

extension KeychainView {
    
    private func saveValue() {
        let savedKeyName = keyName
        do {
            try keychain.storeValue(keyValue, forKey: keyName)
            message = "Successfully saved value for key '\(savedKeyName)'"
            // Clear fields after successful operation
            keyName = ""
            keyValue = ""
        } catch {
            message = "Failed to save value for key '\(savedKeyName)."
        }
        showMessage = true
        hideKeyboard()
    }
    
    private func fetchValue() {
        let fetchedKeyName = keyName
        do {
            storedValue = try keychain.readValue(forKey: keyName) as? String ?? "Not found"
            message = "Value retrieved for key '\(fetchedKeyName)'"
            // Clear fields after successful operation
            keyName = ""
            keyValue = ""
        } catch {
            storedValue = ""
            message = "No value found for key '\(fetchedKeyName)'"
        }
        showMessage = true
        hideKeyboard()
    }
    
    private func deleteValue() {
        let deletedKeyName = keyName
        do {
            try keychain.deleteValue(forKey: keyName)
            storedValue = ""
            message = "Key '\(deletedKeyName)' deleted from keychain"
            // Clear fields after successful operation
            keyName = ""
            keyValue = ""
        } catch {
            message = "Failed to delete key '\(deletedKeyName)' from keychain"
        }
        showMessage = true
        hideKeyboard()
    }
    
    //    private func clearValues() {
    //        let keychain = getKeychain()
    //        if keychain.clear() {
    //            storedValue = ""
    //            message = "ALL key-valuess have been deleted from keychain"
    //            // Clear fields after successful operation
    //            keyName = ""
    //            keyValue = ""
    //        } else {
    //            message = "Failed to delete ALL key-values from keychain"
    //        }
    //        showMessage = true
    //        hideKeyboard()
    //    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
