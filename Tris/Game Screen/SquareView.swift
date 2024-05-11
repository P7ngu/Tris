//
//  SquareView.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import SwiftUI

struct SquareView: View {
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    
    let index: Int
    var body: some View {
      
        Button{
            if !game.isThinking{
                game.makeMove(at: index)
            }
            if game.gameType == .peer {
                let gameMove = MPGameMove(action: .move, playerName: connectionManager.myPeerId.displayName, index: index)
                connectionManager.send(gameMove: gameMove)
            }
        }label: {
            game.gameBoard[index].image
                .resizable()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
        }
        .disabled(game.gameBoard[index].player != nil)
        .foregroundColor(.primary)
    }
}

#Preview {
    SquareView(index: 1)
        .environmentObject(GameService())
        .environmentObject(MPConnectionManager(yourName: "Sample"))
}
