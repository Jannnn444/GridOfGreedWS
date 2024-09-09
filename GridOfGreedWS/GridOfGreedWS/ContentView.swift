//
//  ContentView.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/8.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var websocketManager = WebSocketManager(gridSize: 20)
    
    // Create a 2D array to track which squares are filled
    @State private var isFilled: [Bool] = Array(repeating: false, count: 500)
    
    // Define a grid with 5 squares / 20 squares in one row
    let squares = Array(repeating: GridItem(.fixed(50), spacing: 0), count: 20)
    
    var body: some View {
        
        NavigationView {
            
            ScrollView([.horizontal, .vertical]) {
                LazyVGrid(columns: squares, spacing: 0) { // Remove spacing between columns
                    // Loop through 25 items (5x5 grid)
                    ForEach(0..<500, id: \.self) { index in
                        Rectangle()
                            .fill(isFilled[index] ? Color.cyan : Color.blue)
                            .border(Color.cyan)
                            .cornerRadius(5)
                            .onTapGesture {
                                isFilled[index].toggle()
                            }
                            .frame(width: 50, height: 50)
                    }
                }
                Text("This is the edge of this greedy grid...")
                    .bold()
                    .shadow(radius: 10)
                    .font(.largeTitle)
                    .fontDesign(.serif)
                    .padding()
                    .foregroundStyle(Color.blue)
                    .opacity(0.5)
            }
           
        }
        Text("Greedy folks...")
            .bold()
            .fontDesign(.serif)
            .padding()
            .foregroundStyle(Color.cyan)
            .opacity(0.5)
        .navigationSplitViewStyle(.balanced)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
