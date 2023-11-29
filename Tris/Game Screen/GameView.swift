//
//  GameView.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }.toolbar {
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
}
