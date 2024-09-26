//
//  Config.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/25.
//

import Foundation

// generic

struct SendGridUpdatePost<T:Codable>: Codable {
    let type: State
    let value: T
    
    enum State: String, Codable {
        case START_GAME
        case ACTIVATE_GRID
        case RANDOM
    }
}


