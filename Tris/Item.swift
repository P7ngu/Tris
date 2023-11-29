//
//  Item.swift
//  Tris
//
//  Created by Matteo Perotta on 29/11/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
