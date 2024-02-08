//
//  NetworkManager.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 25.12.23.
//

import Network
import SwiftUI

@MainActor class NetworkManager: ObservableObject {
    @Published private(set) var isConnected = false
    @Published private(set) var connectionDescription = ""
    
    private let networkMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkManager")
    
    init() {
        checkInternetConnection()
    }
    
    func checkInternetConnection() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            Task {
                await MainActor.run {
                    if path.status == .satisfied {
                        self.isConnected = true
                        self.connectionDescription = "Internet connection is good ☺️"
                    } else {
                        self.isConnected = false
                        self.connectionDescription = "Seems like you have a poor internet connection 😔"
                    }
                }
            }
        }
        networkMonitor.start(queue: queue)
    }
}
