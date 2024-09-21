//
//  GameMenu.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/21.
//

import SwiftUI

struct GameMenu: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello Folk")
                
                NavigationLink(destination: HomePage()) {
                    Text("Press For Play")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                HStack{
                    Text("Settings")
                    Image(systemName: "gearshape.fill")
                }
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    GameMenu()
}
