//
//  ContentView.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/8.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var websocketManager = WebSocketManager(gridSize: 20)
    @State private var colorChoice = Color.yellow  // here should receive changes from homepage!!!
    
    // Create a 2D array to track which squares are filled
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
                                .onTapGesture {
                                    isFilled[index].toggle()
                                    websocketManager.sendMessage(message: "hey woof tapping my gird!")
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
                
                
                //        .padding(30)
                
                
                //        Text("Greedy folks...")
                //            .bold()
                //            .fontDesign(.serif)
                //            .foregroundStyle(Color.cyan)
                //            .opacity(0.5)
                //        .navigationSplitViewStyle(.balanced)
                //        .navigationViewStyle(StackNavigationViewStyle())
                //
                //     ColorPicker("", selection: $colorChoice)
                //            .labelsHidden()
                //
            }
        }
    }
}

#Preview {
    ContentView()
}
