import UIKit
import SwiftUI
import shared

struct ComposeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        Main_iosKt.MainViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ComposeView()
                .ignoresSafeArea(.keyboard) // Compose has own keyboard handler
                .tabItem {
                    Label("Login", systemImage: "person.fill")
                }
                .tag(0)
            
            KeychainView()
                .tabItem {
                    Label("Keychain", systemImage: "key.fill")
                }
                .tag(1)
        }
    }
}
