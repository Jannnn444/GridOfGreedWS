//
//  Config.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/25.
//

import Foundation

struct SendGridUpdatePost: Decodable {
    let type: State
    let value: String
    
    enum State: String, Decodable {
        case START_GAME
        case ACTIVATE_GRID
    }
}


