//
//  HomePage.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/10.
//

import SwiftUI

struct SideBar: View {
    @State private var tabState: Tabs = .world
    @State private var colorChoice = Color.greenApple  // here should pass changes to ContentView!!!
    
    var body: some View {
//        Text("HOMEPAGE")
        VStack{
            ZStack {
                HStack {

                    HStack {
                        
                        TabView(tabState: $tabState)
                            .colorMultiply(.secondary)
                            .font(.title)
                            .padding()
                        //  .background(Color.white.shadow(radius: 2)) // Optional: Background and shadow for better visibility
                    }
                    
                    // Page bar
                    // ScrollView {
                    VStack {
                        switch tabState {
                        case .world:
                            ContentView(colorChoice: $colorChoice)
                        case .paint:
                            Text("Where u choose your color")
                            PaintView(colorChoice: $colorChoice)
                        case .userNotes:
                            Text("Where u leave worldwide note, like, comment")
                        case .bag:
                            Text("Where u check ur unique treasure bag")
                        case .shop:
                            Text("Where u buy new fancy cool brush, colors, and themes!")
                        }
//                        ColorPicker("", selection: $colorChoice)
//                               .labelsHidden()
                    }
                    //                }
                }
                
                
            }
            .padding()
        }
    }
}

#Preview {
    SideBar()
}






