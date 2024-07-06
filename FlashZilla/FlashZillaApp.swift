//
//  FlashZillaApp.swift
//  FlashZilla
//
//  Created by Gamıd Khalıdov on 01.07.2024.
//

import SwiftUI
import SwiftData

@main
struct FlashZillaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Card.self)
    }
}
