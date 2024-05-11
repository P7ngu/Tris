//
//  YourNameView.swift
//  Tris
//
//  Created by Matteo Perotta on 11/05/24.
//

import SwiftUI

struct YourNameView: View {
    @AppStorage("yourName") var yourName = ""
    @State private var userName = "" //we create this to avoid forcing the update of the appstorage variable when a user inserts only one letter, causing the app to refresh the view and showing ContentView instead
    
    var body: some View {
        VStack{
            Text("Please decide a name, this will be associated with your device.")
            TextField("Your Name", text: $userName)
                .textFieldStyle(.roundedBorder)
            Button("Set") {
                yourName = userName
            }
            .buttonStyle(.borderedProminent)
            .disabled(userName.isEmpty)
            
            Image("LaunchScreen")
            Spacer()
        }.padding()
            .navigationTitle("Tris")
            .inNavigationStack()
    }
}

#Preview {
    YourNameView()
}
