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
        decodeGridData(from: data)
        print("We handling data: \(data)")
    }
    
    //MARK: Update the grid and receivedGridData
    func updateGrid(with boolArray: [Bool]) {
        let updatedArray = ensure500Elements(in: boolArray)
        DispatchQueue.main.async {
            self.receivedGridData = updatedArray
        }
    }
    
    // MARK: Ensure 500 elements in the array
    private func ensure500Elements(in array: [Bool]) -> [Bool] {
        if array.count < 500 {
            return array + Array(repeating: false, count: 500 - array.count)
        } else if array.count > 500 {
            return Array(array.prefix(500))
        }
        return array
    }
    
    // MARK: Parse a string into a [Bool] array
    func parseBoolArray(from text: String) -> [Bool]? {
        let cleanText = text.trimmingCharacters(in: CharacterSet(charactersIn: "{[]}"))  // Remove brackets
        let components = cleanText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        let boolArray = components.compactMap { component -> Bool? in
            switch component {
            case "true": return true
            case "false": return false
            default: return nil
            }
        }
        return boolArray.count == components.count ? boolArray : nil
    }
    
    // MARK: Decode JSON data into [Bool] and update the grid
    private func decodeGridData(from data: Data) {
        do {
            let decodedGrid = try JSONDecoder().decode([Bool].self, from: data)
            updateGrid(with: decodedGrid)
        } catch {
            print("Decoding error: \(error)")
        }
    }
    
    // send message can have a dynamic value type for message by using generic
    // Send a message to WebSocket server
    func sendMessage<T>(message: SendGridUpdatePost<T>) {
        
        let encodedMessage = encodeJSON(message: message)
        guard let encodedMessage = encodedMessage  else { return }  // if it nil, return
        
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
    
    // Disconnect WebSocket
    func disconnect() {
        websocketTask?.cancel(with: .goingAway, reason: nil)
        print("Disconnected from WebSocket server")
    }
}

//chmod +x game-server      (1)
//sudo: ./game-server:      (2)

