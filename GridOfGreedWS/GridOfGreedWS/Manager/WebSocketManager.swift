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
//    @Published var grid: [Bool]?
    @Published var grid: [Bool] = Array(repeating: false, count: 500)
 
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
        websocketTask?.resume() //this called on the websocket task, which initiates the connection to the WS server
        receiveMessage() //continuosly listening for incoming messages from the websocket server
    }

    
    //MARK: Update the grid and receivedGridData
    func updateGrid(with boolArray: [Bool]) {
            DispatchQueue.main.async {
                // Ensure the array has exactly 500 elements to prevent index out-of-range errors
                if boolArray.count == 500 {
                    self.grid = boolArray
                } else {
                    print("Received grid data of incorrect size.")
                }
            }
        }
    
    func receiveMessage() {
        websocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let jsonData):
                    //Decode the received data into WebsocketResponse<Bool>
                    if let decodedResponse: WebsocketResponse<Bool> = self?.decodeJSON(message: jsonData, type: WebsocketResponse<Bool>.self) {
                        // Handle the decoded message, e.g., update UI or state
                        print("Received and decoded message: \(decodedResponse.data)")
                        
                        
                        // Update the grid with new boolean array
                        self?.updateGrid(with: decodedResponse.data)
                        
                        // Unwrap the state safely first
                        guard let responseState = SendGridUpdatePost<[Bool]>.State(rawValue: "response") else {
                            print("Invalid state for SendGridUpdatePost")
                            return
                        }
                        
                        // Create a new message (or response) using SendGridUpdatePost
                        let newMsgs = SendGridUpdatePost(type: responseState , value: decodedResponse.data)
                        
                        // Send the new message back to the WebSocket server
                        self?.sendMessage(message: newMsgs)
                         
                    }
                case .string(let text):
                    print("Received SString: \(text)")
                    
                    if text == "startgame" {
                        print("Received SString - Starting the game")
                        self?.updateGrid(with: Array(repeating: false, count: 500)) //Reset a grid
                    } else if text == "update" {
                        print("Upating grid state")
                    } else {
                        // when JSON-encoded string
                        if let data = text.data(using: .utf8),
                           let deccodedResponse: WebsocketResponse<Bool> = self?.decodeJSON(message: data, type: WebsocketResponse<Bool>.self) {
                            self?.updateGrid(with: deccodedResponse.data)
                        } else {
                            print("Unknown SString received: \(text)")
                        }
                    }
                    
                @unknown default:
                    print("Unknown messge format received")
                }
            case .failure(let error):
                print("Error receiving WS messages: \(error.localizedDescription)")
            }
            self?.receiveMessage() //Keep listening for more messages
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
    // Generic function for encoding any type that conforms to Encodable. Returns Data or nil.
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
    
    // Generic,function for decoding JSON into any type that conforms to Decodable. Takes Data as input
    func decodeJSON<T:Decodable>(message: Data, type: T.Type) -> T? {

        let jsonDecoder = JSONDecoder()
        do {
            let decodedObject = try jsonDecoder.decode(T.self, from: message)
            return decodedObject
        } catch {
            print("Decode Json error: \(error.localizedDescription)")
            return nil
        }
    }
    

    // Disconnect WebSocket
    func disconnect() {
        websocketTask?.cancel(with: .goingAway, reason: nil)
        print("Disconnected from WebSocket server")
    }
}




//chmod +x game-server      (1)
//sudo ./game-server:      (2)

