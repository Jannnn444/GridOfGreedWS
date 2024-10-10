//
//  PaintView.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/10/9.
//

import SwiftUI

struct PaintView: View {
    @Binding var colorChoice: Color  // Use @Binding to receive color choice
    
    var body: some View {
        ColorPicker("Pick a Color", selection: $colorChoice)
             .labelsHidden()
    }
}
