//
//  WebsocketResponse.swift
//  GridOfGreedWS
//
//  Created by yucian huang on 2024/9/30.
//

import Foundation

struct WebsocketResponse<T:Codable>: Codable {
  var data: [Bool]
}

