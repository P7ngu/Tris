//
//  TrisApp.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import SwiftUI
import SwiftData

@main
struct TrisApp: App {
    @AppStorage("yourName") var yourName = ""
    @StateObject var game = GameService()


    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty{
                YourNameView()
            } else {
                ContentView(yourName: yourName)
                    .environmentObject(game)
                //we set the game here, so that it can be passed anywhere using the environment
            }
        }
       
    }
}
