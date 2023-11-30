//
//  ContentView.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var game: GameService
    @State private var gameType: GameType = .undetermined
    @State private var yourName = ""
    @State private var opponentName = ""
    @State private var startGame = false
    @FocusState private var focus: Bool //for the keyboard dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack{
            VStack{
                Picker("Select game", selection: $gameType){
                    Text("Select game type").tag(GameType.undetermined)
                    Text("Share one device").tag(GameType.single)
                    Text("Challenge an AI").tag(GameType.bot)
                    Text("Challenge a friend").tag(GameType.peer)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
                //.accentColor(.primary)
                
                Text(gameType.description)
                    .padding()
                
                VStack{
                    switch gameType {
                    case .single:
                        VStack{
                            TextField("Your Name", text: $yourName)
                            TextField("Opponent Name", text: $opponentName)
                        }
                    case .bot:
                        TextField("Your Name", text: $yourName)
                    case .peer:
                        EmptyView()
                    case .undetermined:
                        EmptyView()
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .focused($focus)
                .frame(width: 350)
                
                if gameType != .peer {
                    Button("Start Game"){
                        game.setupGame(gameType: gameType, player1name: yourName, player2name: opponentName)
                        focus = false
                        startGame.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        gameType == .undetermined ||
                        gameType == . bot && yourName.isEmpty ||
                        gameType == .single &&
                        (yourName.isEmpty || opponentName.isEmpty)
                    )
                    Image("LaunchScreen")
                }
                Spacer()
                
                
            } 
            .padding()
            .navigationTitle("Xs or Os")
            .fullScreenCover(isPresented: $startGame) {
                GameView()
            }
            .inNavigationStack()
        }
        
        
    }
      

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(GameService())
}
