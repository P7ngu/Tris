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
    @AppStorage ("yourName") private var yourName = ""
    @State private var opponentName = ""
    @State private var startGame = false
    @FocusState private var focus: Bool //for the keyboard dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var changeName = false
    @State private var newName = ""
    
    //For connection purposes, to have it in all subviews, must add it as an environment object
    @StateObject var connectionManager: MPConnectionManager
    
    init(yourName:String) {
        self.yourName = yourName
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
    }

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
                            TextField("Opponent Name", text: $opponentName)
                        }
                    case .bot:
                      EmptyView()
                    case .peer:
                        MPPeersView(startGame: $startGame)
                            .environmentObject(connectionManager)
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
                        gameType == .single &&
                        (opponentName.isEmpty)
                    )
                    Image("LaunchScreen")
                    Text("Your name is \(yourName)")
                    Button("Change my name"){
                        changeName.toggle()
                    }
                    .buttonStyle(.bordered)
                }
                Spacer()
                
                
            } 
            .padding()
            .navigationTitle("Xs or Os")
            .fullScreenCover(isPresented: $startGame) {
                GameView()
                    .environmentObject(connectionManager) //injected connection manager into the environment, do it also in the gameview 
            }
            .alert("Change Name", isPresented: $changeName, actions: {
                TextField("New name", text: $newName)
                Button("OK", role: .destructive) {
                    yourName = newName
                    exit(-1)
                }
                Button("Cancel", role: .cancel) {}
            }, message: {
                Text("Tapping on the OK button will quit the App so you can relaunch with your new, changed name.")
            })
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
    ContentView(yourName: "Testing")
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(GameService())
}
