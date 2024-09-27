//
//  WebSocketManager.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/9.
//

import Foundation

class WebSocketManager: ObservableObject {
    
    private var websocketTask: URLSessionWebSocketTask?
    
    // Represents the grid state
    @Published var grid: [Bool]?
        @Published var receivedGridData: [Bool]? // TODO: remove all the references of this
    
    init() {
        self.connect()
    }
    
    // MARK: Connect to WebSocket server
    func connect() {
        guard let url = URL(string: "ws://localhost:6666/ws") else {
            print("Invalid WebSocket URL")
            return
        }
        websocketTask = URLSession.shared.webSocketTask(with: url)
        websocketTask?.resume()
        receiveMessage()
    }
    
    // MARK: Receive messages from WebSocket
    func receiveMessage() {
        websocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error when receiving messages: \(error.localizedDescription)")
                
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received String message: \(text)")
                    self?.handleReceivedMessages(text)
                    
                case .data(let data):
                    print("Received Binarry message")
                    self?.handleReceivedData(data)
                    
                @unknown default:
                    print("Unknown message type received")
                }
            }
            
            self?.receiveMessage() // Keep receiving recursive messages
        }
    }
    
    // MARK: Handle string messages received from WebSocket
    private func handleReceivedMessages(_ message: String) {
       print("FINAL STRING FROM SERVER: \(message)")
    }
    
    //MARK: Handle binary data received from WebSocket
    private func handleReceivedData(_ data: Data) {
        print("FINAL DATA FROM SERVER: \(data)")
    }
    
    //MARK: Update the grid and receivedGridData
    func updateGrid(with element: String) {
        DispatchQueue.main.async {
//            self.grid
        }
    }
    
    // send message can have a dynamic value type for message by using generic
    // Send a message to WebSocket server
    func sendMessage<T>(message: SendGridUpdatePost<T>) {
        
        let encodedMessage = encodeJSON(message: message)
        guard let encodedMessage = encodedMessage  else { return }  // guard it nil, return
        
        let message = URLSessionWebSocketTask.Message.data(encodedMessage)
        
        websocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            } else {
                print("Message sent successfully")
            }
        }
    }
    
    // generic, when we encode we want to encode any type. Return Data or nil
    func encodeJSON<T:Encodable>(message: T) -> Data? {
        let jsonEncoder = JSONEncoder()
        var jsonResultData: Data
        
        do {
            jsonResultData = try jsonEncoder.encode(message)
            return jsonResultData
        } catch {
            print("Encode Json error : \(error.localizedDescription)")
            return nil //optional
        }
    }
    
    func decodeJSON<T>(message: T) -> String {
        return ""
    }
    
    // Disconnect WebSocket
    func disconnect() {
        websocketTask?.cancel(with: .goingAway, reason: nil)
        print("Disconnected from WebSocket server")
    }
}

//chmod +x game-server      (1)
//sudo: ./game-server:      (2)

