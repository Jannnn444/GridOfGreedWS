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
    
    init(gridSize: Int) {
        self.grid = Array(repeating: true, count: gridSize)
        connect() //eveytime it run itself
        receiveMessage()
        // [false, false, false, false, false]
    }
    //MARK: Established a connection to the websocket server.
    /// <#Description#>
    func connect() {
        // Create an url object
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
                print("Received Message: \(message)")

                switch message {
                case .string(let text):
                    print("Received string message: \(text)")
                case .data(let data):
                    // Explicitly capture self here
                    print("My data for debug: \(data)")
                    let result = self?.decodedJson(dataTiBeDecode: data)
                    print("Received binary data: \(result)")
                @unknown default:
                    print("Unknown message type received")
                }
                
                //Keep receiving datas
                self?.receiveMessage() // recursive -> loops keep going
            }
            //handle recieved message
            
        }
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
}

//chmod +x ./ws-server
//sudo ./ws-server
