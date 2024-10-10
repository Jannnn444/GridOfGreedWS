//
//  ContentView.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/8.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var websocketManager = WebSocketManager()
    @Binding var colorChoice: Color  // Use @Binding to receive color choice
    
    
   /* @State private var colorChoice = Color.dracula*/  // here should receive changes from homepage!!!
    
//    Create a 2D array to track which squares are filled

    var body: some View {
  
        ScrollView([.horizontal, .vertical]) {
            VStack{
                VStack {

                    // Define a grid with 5 squares / 20 squares in one row
                    let squares = Array(repeating: GridItem(.fixed(50), spacing: 0), count: (websocketManager.grid?.count ?? 10) / 3)
                    
                    LazyVGrid(columns: squares, spacing: 0) { // Remove spacing between columns
                       
                        // Loop through 500 items (20x25 grid)
                        ForEach(0..<(websocketManager.grid?.count ?? 10), id: \.self) { index in
                          
                            Rectangle()
                                .fill((websocketManager.grid?[index] ?? false) ? colorChoice : Color.white)
                                .border(Color.secondary)
                                .cornerRadius(5)
                                .frame(width: 50, height: 50)
                                .onTapGesture {
                                    // Send the grid index to the WebSocket server when tapped
                                    websocketManager.sendMessage(message: SendGridUpdatePost(type: .ACTIVATE_GRID, value: index))
                            }
                        }
                    }
                } 
                Group{
                    Text("This is the edge of this greedy grid ")
                        .bold()
                        .shadow(radius: 10)
                        .font(.title)
                        .fontDesign(.serif)
                        .foregroundStyle(Color.blue)
                        .opacity(0.5)
                }.padding()
            }
        }
        .onAppear {
            // Send a message to start the game when the view appears
            websocketManager.sendMessage(message: SendGridUpdatePost(type: .START_GAME, value: ""))
          
        }
        .onDisappear {
            websocketManager.disconnect()
        }
    }
}



// TODO: WS save the color data?
// NOTE: Now the server can succcesfully encoded and decoded, which also means my Server saved the data, and each time i startgame will updated.
