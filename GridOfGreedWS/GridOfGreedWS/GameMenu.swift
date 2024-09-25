//
//  GameMenu.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/21.
//

import SwiftUI

struct GameMenu: View {
    
    @StateObject var websocketmanager = WebSocketManager(gridSize: 500)
    
    var body: some View {
        
        // Maybe not use navigation destination, but use State to let it change page automatically
        
        NavigationStack {
            VStack {
                Text("Hello Folk")
                
                NavigationLink(destination: SideBar()) {
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
