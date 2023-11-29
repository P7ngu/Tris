//
//  ViewModifier.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import SwiftUI

struct NavStackContainer: ViewModifier{
    func body(content: Content) -> some View {
        if #available(iOS 16, *){
            NavigationStack{
                content
            }
        } else {
            NavigationView{
                content
            }
            .navigationViewStyle(.stack)
        }
        
    }
    
}

extension View {
    public func inNavigationStack() -> some View{
        return self.modifier(NavStackContainer())
    }
}
