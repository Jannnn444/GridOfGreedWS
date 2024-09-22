//
//  ContentView.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/8.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var websocketManager = WebSocketManager(gridSize: 500)
    @State private var colorChoice = Color.yellow  // here should receive changes from homepage!!!
    
//    Create a 2D array to track which squares are filled
    @State private var isFilled: [Bool] = Array(repeating: false, count: 500)
        
    // Define a grid with 5 squares / 20 squares in one row
    let squares = Array(repeating: GridItem(.fixed(50), spacing: 0), count: 20)
    
    var body: some View {
  
        ScrollView([.horizontal, .vertical]) {
            VStack{
                VStack {
                    HStack {
                        ColorPicker("", selection: $colorChoice)
                            .labelsHidden()
                    }
                    Spacer()
                    LazyVGrid(columns: squares, spacing: 0) { // Remove spacing between columns
                       
                        // Loop through 25 items (5x5 grid)
                        ForEach(0..<500, id: \.self) { index in
                            Rectangle()
                                .fill(isFilled[index] ? colorChoice : Color.white)
                                .border(Color.secondary)
                                .cornerRadius(5)
//                                .onTapGesture {
//                                    // Create a temporary arrray to modify and assign back
//                                    var updateGrid = websocketManager.receivedGridData
//                                    updateGrid[index].toggle()
//                                    // Above: Toggle the value at the index
//                                    
//                                    // Here assign the updated grid back to trigger the UI update
//                                    websocketManager.receivedGridData = updateGrid
//                                    
//                                    // Toggle grid Boolean by tapping
//                                    websocketManager.receivedGridData[index].toggle()
//                                    
//                                }
//                                .frame(width: 50, height: 50)
                            
                                .onTapGesture {
                                    isFilled[index].toggle()
                                    websocketManager.receiveMessage()
                                }
                                .frame(width: 50, height: 50)
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
        .onAppear(perform: {
            websocketManager.sendMessage(message: "startgame")
        })
    }
        
}
// [V] 20240921 TODO: why UI didnt triggerd repaint when receiving the [Bool]


#Preview {
    ContentView()
}
