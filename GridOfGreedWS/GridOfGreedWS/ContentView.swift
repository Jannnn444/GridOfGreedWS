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
    
    // Create a 2D array to track which squares are filled
    
    @State private var isFilled: [Bool] = Array(repeating: false, count: 500)
//    @State private var isFilled: [Bool] = websocketManager.receivedGridData
    
        
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
                                .onTapGesture {
                                    isFilled[index].toggle()
                                }
                                .frame(width: 50, height: 50)
                        }
                    }
                } 
                Text("This is the edge of this greedy grid...")
                    .bold()
                    .shadow(radius: 10)
                    .font(.largeTitle)
                    .fontDesign(.serif)
                    .foregroundStyle(Color.blue)
                    .opacity(0.5)
                
            }
            .onReceive(websocketManager.$receivedGridData) { newGridData in
                if newGridData.count == isFilled.count {
                    isFilled = newGridData // Update the grid with the new data
                }
            }
        }.onAppear(perform: {
            websocketManager.sendMessage(message: "startgame")
        })
    }
        
}
// 20240921 TODO: why UI didnt triggerd repaint when receiving the [Bool]\


#Preview {
    ContentView()
}
