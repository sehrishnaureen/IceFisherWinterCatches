import SwiftUI

struct RemoteContentView: UIViewControllerRepresentable {
    let address: String
    
    func makeUIViewController(context: Context) -> RemoteContentController {
        return RemoteContentController(address: address)
    }
    
    func updateUIViewController(_ uiViewController: RemoteContentController, context: Context) {}
}
