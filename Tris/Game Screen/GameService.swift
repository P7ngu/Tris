//
//  GameService.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import Foundation
import SwiftUI


//Since all of this is needed to update the UI
@MainActor

class GameService: ObservableObject{
    //since the game will change a lot, we need to observe different thingd
    
    @Published var player1 = Player(gamePiece: .x, name: "Player 1")
    @Published var player2 = Player(gamePiece: .o, name: "Player 2")
    
    @Published var gameBoard = GameSquare.reset
    
    @Published var possibleMoves = Move.all
    @Published var gameOver = false
    
    //To display the progress bar
    @Published var isThinking = false
    
    //a simple var since it is not subject to change, unlike the other properties
    var gameType = GameType.single
    
    var currentPlayer: Player{
        if player1.isCurrent{
            return player1
        } else{
            return player2
        }
    }
    
    var gameStarted: Bool{
        player1.isCurrent || player2.isCurrent
    }
    
    var boardDisabled: Bool{
        gameOver || !gameStarted || isThinking
    }
    
    
    func setupGame(gameType: GameType, player1name: String, player2name: String){
        switch gameType {
        case .single:
            self.gameType = .single
            player2.name = player2name
        case .bot:
            self.gameType = .bot
            player2.name = UIDevice.current.name
        case .peer:
            self.gameType = .peer
        case .undetermined:
            break
        }
        player1.name = player1name //after the switch, since this always needs to be updated
    }
    
    func reset(){
        player1.isCurrent = false
        player2.isCurrent = false
        player1.moves.removeAll()
        player2.moves.removeAll()
        
        gameOver = false
        possibleMoves = Move.all
        
        gameBoard = GameSquare.reset
        
        
    }
    
    func updateMoves(index: Int){
        if player1.isCurrent{
            player1.moves.append(index+1)
            gameBoard[index].player = player1
        } else {
            player2.moves.append(index+1)
            gameBoard[index].player = player2
        }
    }
    
    func checkIfWinner(){
        if player1.isWinner || player2.isWinner{
            gameOver = true
        }
    }
    
    
    func toggleCurrent(){
        player1.isCurrent.toggle()
        player2.isCurrent.toggle()
    }
    
    func makeMove(at index: Int){
        if gameBoard[index].player == nil{
            withAnimation{
                updateMoves(index: index)
            }
            checkIfWinner()
            if !gameOver {
                if let matchingIndex = possibleMoves.firstIndex(where: { $0 == (index+1)}) {
                    possibleMoves.remove(at: matchingIndex)
                }
                toggleCurrent()
                if gameType == .bot && currentPlayer.name == player2.name {
                    Task { //Async
                        await deviceMove()
                    }
                }
            }
            if possibleMoves.isEmpty{
                gameOver = true
            }
        }
    }
    
    func deviceMove() async {
        isThinking.toggle()
        try? await Task.sleep(nanoseconds: 1_000_000_000) //Sleep
        if let move = possibleMoves.randomElement() {
            if let matchingIndex = Move.all.firstIndex(where: {$0 == move}){
                makeMove(at: matchingIndex)
            }
        }
        isThinking.toggle()
    }
    
}
