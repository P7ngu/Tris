//
//  GameView.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameService
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            if[game.player1.isCurrent,game.player2.isCurrent].allSatisfy{ $0 == false } {
                Text("Select a player to start")
            }
            
            HStack{
                Button(game.player1.name){
                    game.player1.isCurrent = true
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
               
                
                Button(game.player2.name){
                    game.player2.isCurrent = true
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player2.isCurrent))
            }
            .disabled(game.gameStarted)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Button("End Game"){
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Game")
        .inNavigationStack() //embeds everything inside of a navigation stack as specified in the viewmodifier
    }
}

#Preview {
    GameView()
        .environmentObject(GameService())
}


struct PlayerButtonStyle: ButtonStyle{
    let isCurrent: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background( RoundedRectangle(cornerRadius: 10)
                .fill(isCurrent ? Color.green : Color.gray)
                         //green if p1 is current, gray otherwise
            )
            .foregroundColor(.white)
        
    }
}
