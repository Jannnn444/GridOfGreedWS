//
//  WebSocketManager.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/9.
//

import Foundation

// allow @Publish for observing ur objects
class WebSocketManager: ObservableObject {
    
    private var websocketTask: URLSessionWebSocketTask?
    
    // represents the grid state
    @Published var grid: [Bool]
    @Published var receivedGridData: [Bool] = Array(repeating: false, count: 500)
    
    init(gridSize: Int) {
        self.grid = Array(repeating: true, count: gridSize)
        
        //connect on initialization
        connect()
        receiveMessage()
    }
    
    //MARK: Established a connection to Websocket Server.
    func connect() {
        guard let url = URL(string: "ws://localhost:6666/ws") else {
           print("Invalid WebSocket URL")
           return
        }
        
        // Ensure URLSessionWebSocketTask is not nil before calling resume()
        websocketTask = URLSession.shared.webSocketTask(with: url)
        websocketTask?.resume()
        
        // start receiving messages from connected WS server.
        receiveMessage()
    }
    
    //MARK: Read in websocket messages from active websocket connecting
    func receiveMessage() {
        websocketTask?.receive { [weak self] result in
            switch result {
                
            case .failure(let error):
                print("Error when receiving messages :\(error.localizedDescription)")
                
            case .success(let message):
                switch message {
                    
                case .string(let text):
                    print("Received STRING message: \(text)")
                    
                    // MARK: Parse the received string into an array of Bools
                    if var boolArray = self?.parseBoolArray(from: text) {
                        
                        if boolArray.count == 500 {
                            // Array has exactly 500 elements
                            print("Valid array of 500 Booleans received!")
                        } else if boolArray.count < 500 {
                            // Array has fewer than 500 elements, so append `false` values
                            print("boolArray.count doesn't have 500 elements, so let's fix it.")
                            boolArray.append(contentsOf: Array(repeating: false, count: 500 - boolArray.count))
                            // Convert back to a string
                            let boolString = "[" + boolArray.map { String($0) }.joined(separator: ",") + "]"
                            print("Converted back to string (padded with false): \(boolString)")
                        } else if boolArray.count > 500 {
                            // Array has more than 500 elements, so truncate it
                            print("boolArray.count is greater than 500, truncating.")
                            boolArray = Array(boolArray.prefix(500))
                            // Convert back to a string
                            let boolString = "[" + boolArray.map { String($0) }.joined(separator: ",") + "]"
                            print("Converted back to string (truncated): \(boolString)")
                        }
                        
                    } else {
                        print("Failed to parse string into [Bool].")
                    }
                    
                    print("Received STRING : \(text)")
                    
                 
                case .data(let data):
                    // Explicitly capture self here
                    print("My data for debug: \(data)")
                    let result = self?.decodedJson(dataTiBeDecode: data)
                    print("Received binary data: \(result)")
                @unknown default:
                    print("Unknown message type received")
                }
                
                // Keep receiving messages recursively
                self?.receiveMessage()
            }
        }
    }
    
    // MARK: Helper for Parsing the String into [Bool]
    func parseBoolArray(from text: String) -> [Bool]? {
        let cleanText = text.trimmingCharacters(in: CharacterSet(charactersIn: "[]")) //Remove brackets
        let components = cleanText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        let boolArray = components.compactMap { component -> Bool? in
            
            if component == "true" {
                return true
            } else if component == "false" {
                return false
            } else {
                return nil
            }
              
            
            
        }
    // Return nil if any element couldn't be parsed
        return boolArray.count == components.count ? boolArray : nil
    }
    
    
    // MARK: Handel string messages received from websocket
    private func handleReceivedMessages(_ message: String) {
        if let data = message.data(using: .utf8) {
         decodeGridData(from: data)
        } else {
            print("Failed to convert message to Data")
        }
    }
    
    // Handle data messages received from WebSocket
    private func handleReceivedData(_ data: Data) {
        decodeGridData(from: data)
    }
    
    // Send message to WebSocket server
    func sendMessage(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        websocketTask?.send(message) { error in
            if let error  = error {
                print("Sending Websocket error : \(error.localizedDescription)")
            } else {
                print("Message sent successfully")
            }
        }
    }
    
    // Decode the received data and update the grid
    private func decodeGridData(from data: Data) {
        do {
            var decodeGrid = try JSONDecoder().decode([Bool].self, from: data)
            
            //Ensure if 500 elements
            if decodeGrid.count < 500 {
                decodeGrid.append(contentsOf: Array(repeating: false, count: 500 - decodeGrid.count))
            } else if decodeGrid.count > 500 {
                decodeGrid = Array(decodeGrid.prefix(500))
            }
            
            // Update the state with the 500-element array
            DispatchQueue.main.async {
                self.receivedGridData = decodeGrid
            }
            
        } catch {
            print("Decoding error: \(error)")
        }
    }
    
    
    func disconnect() {
        websocketTask?.cancel(with: .goingAway, reason: nil)
        print("Disconnected from WebsSocket server")
    }
    
    func decodedJson(dataTiBeDecode: Data) -> [Bool] {
        do {
            let decodedGrid = try JSONDecoder().decode([Bool].self, from: dataTiBeDecode)
            DispatchQueue.main.async { [weak self] in
                self?.grid = decodedGrid //use self explicity
            }
            return decodedGrid
        } catch {
            print("Error decoding grid data: \(error)")
            return []
        }
    }
    
    //MARK: After we received the message, decode and update a receivedsGridData
    func recieveMessage() {
        //Websocket receive logic
        //REceive data message is a string
        let message = "[true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]"
        //Convert the message to Data for JSON decoding
        if let data = message.data(using: .utf8) {
            do {
                //Decode the data into a boolean array
                var decodedGrid = try JSONDecoder().decode([Bool].self, from: data)
                
                //ensure the array has 500 elements
                if decodedGrid.count < 500 {
                    decodedGrid.append(contentsOf: Array(repeating: false, count: 500 - decodedGrid.count))
                } else if decodedGrid.count > 500 {
                    decodedGrid = Array(decodedGrid.prefix(500))
                    
                }
                
                //MARK: Update the state with 500-element array
                DispatchQueue.main.async {
                    self.receivedGridData = decodedGrid
                }
            } catch {
                print("Decoding error: \(error)")
            }
        } else {
            print("Failed to convert message to Data")
        }
    }
    
}

//chmod +x ./ws-server
