//
//  GameModels.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import Foundation

enum GameType {
    
    case single, bot, peer, undetermined
    
    var description: String{
        switch self {
        case .single:
            return "Share your device and play against a friend"
        case .bot:
        return "Play against an AI"
        case .peer:
            return "Invite someone to play on both devices"
        case .undetermined:
            return ""
        }
    }
}
