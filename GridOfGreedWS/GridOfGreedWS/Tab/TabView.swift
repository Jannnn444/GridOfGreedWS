//
//  TabView.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/10.
//

import SwiftUI

struct TabView: View {
    
    @Binding var tabState: Tabs
    
    var body: some View {
        VStack {
            // Button1
            Button {
                tabState = .world
            } label: {
                VStack {
                    Image(systemName: "gamecontroller")
                    Text("World")
                        .font(.system(size: 10, weight: .regular, design: .serif))
                }
            }.padding(.bottom, 10) .padding(.leading, -10)
            
            // Button2
            Button {
                tabState = .paint
            } label: {
                VStack {
                    Image(systemName: "paintbrush")
                    Text("Paint")
                        .font(.system(size: 10, weight: .regular, design: .serif))
                }
            }.padding(.bottom, 10) .padding(.leading, -10)
            
            //Button3
            Button {
                tabState = .userNotes
            } label: {
                VStack {
                    Image(systemName: "note.text")
                    Text("Paint")
                        .font(.system(size: 10, weight: .regular, design: .serif))
                }
            }.padding(.bottom, 10) .padding(.leading, -10)
            
            //Button4
            Button {
                tabState = .bag
            } label: {
                VStack {
                    Image(systemName: "bag")
                    Text("Note")
                        .font(.system(size: 10, weight: .regular, design: .serif))
                }
            }.padding(.bottom, 10) .padding(.leading, -10)
            
            //Button5
            Button {
                tabState = .shop
            } label: {
                VStack {
                    Image(systemName: "cart")
                    Text("Note")
                        .font(.system(size: 10, weight: .regular, design: .serif))
                        .bold()
                }
            }.padding(.bottom, 10) .padding(.leading, -10)
        }
        
        
    }
}
