//
//  Card.swift
//  FlashZilla
//
//  Created by Gamıd Khalıdov on 02.07.2024.
//

import Foundation
import SwiftData

@Model
class Card {
    var prompt: String
    var answer: String
    var id = UUID()
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    
    init(prompt: String, answer: String, id: UUID = UUID()) {
        self.prompt = prompt
        self.answer = answer
        self.id = id
    }
}
