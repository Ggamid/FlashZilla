//
//  ContentView.swift
//  FlashZilla
//
//  Created by Gamıd Khalıdov on 01.07.2024.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset*10)
    }
}

struct ContentView: View {
    
    @State private var cards = Array<Card>(repeating: .example, count: 10)
    
    @State var timeRemaining = 10
    
    @Environment(\.scenePhase) var scenePhase
    @State var isActive = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            VStack{
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .padding()
                    .background{
                        Rectangle()
                            .fill(.black)
                            .opacity(0.4)
                            .clipShape(.capsule)
                    }
                if cards.isEmpty || timeRemaining == 0 {
                    Button{
                        resetCards()
                    } label: {
                        Text("Restart")
                            .font(.largeTitle)
                            .padding()
                            .background{
                                Rectangle()
                                    .fill(.black)
                                    .opacity(0.4)
                                    .clipShape(.capsule)
                            }
                    }
                }
                
                ZStack{
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                   removeCard(at: index)
                               }
                        }
                            .stacked(at: index, in: cards.count)
                            .allowsHitTesting(!(timeRemaining == 0))
                    }
                }
            }
        }
        .onReceive(timer, perform: { _ in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                    timeRemaining -= 1
            } else {
                
            }
        })
        .onChange(of: scenePhase) { _, _ in
            if scenePhase == .active {
                isActive = true
            } else {
                isActive = false
            }
        }
    }
    
    func removeCard(at index: Int) {
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        cards = Array<Card>(repeating: .example, count: 10)
        timeRemaining = 100
        isActive = true
    }
}

#Preview {
    ContentView()
}
