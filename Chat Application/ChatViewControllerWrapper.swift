//
//  ChatViewControllerWrapper.swift
//  Chat Application
//
//  Created by Darahaas Nallagatla on 2/24/24.
//

import Foundation
import SwiftUI

struct ChatViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ChatViewController {
        return ChatViewController()
    }
    
    func updateUIViewController(_ uiViewController: ChatViewController, context: Context) {
        // Update the view controller if needed.
    }
}

struct ChatViewControllerWrapper_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewControllerWrapper()
    }
}
