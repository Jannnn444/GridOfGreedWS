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
        // [false, false, false, false, false]
    }
    //MARK: Established a connection to the websocket server.
    func connect() {
        // Create an url object
        guard let url = URL(string: "wss://localhost:6666/ws") else { return }
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
                print("Error when receiving messages :\(error)")
            case .success(let message):
                print("Received Message: \(message)")
                switch message {
                case .string(let text):
                    print("Received string message: \(text)")
                case .data(let data):
                    print("Received binary data: \(data)")
                }
                self?.receiveMessage() // recursive -> loops keep going
            }
            //handle recieved message
            
        }
    }
    
    func disconnect() {
        websocketTask?.cancel(with: .goingAway, reason: nil)
    }
}



//class Person{
//    var name: String
//    
//    init(name: String) {
//        self.name = name
//    }
//}
