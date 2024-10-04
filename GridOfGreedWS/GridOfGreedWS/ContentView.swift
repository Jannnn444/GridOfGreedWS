//
//  ContentView.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/8.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var websocketManager = WebSocketManager()
    
    @State private var colorChoice = Color.yellow  // here should receive changes from homepage!!!
    
//    Create a 2D array to track which squares are filled

//    Define a grid with 5 squares / 20 squares in one row
    let squares = Array(repeating: GridItem(.fixed(50), spacing: 0), count: 20)
    
    var body: some View {
  
        ScrollView([.horizontal, .vertical]) {
            VStack{
                VStack {
                    HStack(alignment: .top) {
                        ColorPicker("", selection: $colorChoice)
                            .labelsHidden()
                    }
                    Spacer()
                    LazyVGrid(columns: squares, spacing: 0) { // Remove spacing between columns
                       
                        // Loop through 500 items (20x25 grid)
                        ForEach(0..<10, id: \.self) { index in
                          
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
                
                Text("This is the edge of this greedy grid ")
                    .bold()
                    .shadow(radius: 10)
                    .font(.largeTitle)
                    .fontDesign(.serif)
                    .foregroundStyle(Color.blue)
                    .opacity(0.5)
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

#Preview {
    ContentView()
}










