//
//  Card.swift
//  FlashZilla
//
//  Created by Gamıd Khalıdov on 02.07.2024.
//

import Foundation

struct Card: Codable, Identifiable {
    var prompt: String
    var answer: String
    var id = UUID()
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
