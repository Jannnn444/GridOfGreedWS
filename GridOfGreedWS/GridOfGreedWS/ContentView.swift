//
//  ContentView.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/8.
//

import SwiftUI

struct ContentView: View {
    
    // Create a 2D array to track which squares are filled
    @State private var isFilled: [Bool] = Array(repeating: false, count: 25)
    
    // Define a grid with 5 squares
    let square = Array(repeating: GridItem(.fixed(20)), count: 5)
    
    var body: some View {
        LazyVGrid(columns: square) {
            // Loop through 25 items (5x5 grid)
            ForEach(0..<25, id: \.self) { index in
                Image(systemName: isFilled[index] ? "square.fill" : "square")
                    .imageScale(.large)
                    .foregroundStyle(Color.cyan)
                    .onTapGesture {
                        isFilled[index].toggle()
                    }
                    .frame(width: 20, height: 20)
            }
        }.padding()
      
        Text("Greedy folks...")
            .bold()
            .fontDesign(.serif)
            .padding()
            .foregroundStyle(Color.cyan)
    }
}

#Preview {
    ContentView()
}
