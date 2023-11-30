//
//  SquareView.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import SwiftUI

struct SquareView: View {
    @EnvironmentObject var game: GameService
    let index: Int
    var body: some View {
      
        Button{
            game.makeMove(at: index)
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
}
