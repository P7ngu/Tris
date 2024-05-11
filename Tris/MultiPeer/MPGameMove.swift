//
//  MPGameMove.swift
//  Tris
//
//  Created by Matteo Perotta on 11/05/24.
//

import Foundation

struct MPGameMove: Codable {
    enum Action: Int, Codable {//Actions performable during the game
        case start, move, reset, end
    }
    
    let action: Action
    let playerName: String?
    let index: Int //For the move
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
}
