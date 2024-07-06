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
        return self.offset(y: offset*35)
    }
    
    func scaled(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.scaleEffect(1-(offset)*0.1)
    }
}

struct ContentView: View {
    
    @State private var cards = Array<Card>(repeating: .example, count: 10)
    
    @State var timeRemaining = 100
    
    @Environment(\.scenePhase) var scenePhase
    @State var isActive = true
    
    @State private var showingEditScreen = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            
            Rectangle()
                .ignoresSafeArea()
            
            Circle()
                .fill(.blue)
                .frame(height: 1000)
                
            
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 200, height: 60)
                        .opacity(0.7)
                    Text("Time: \(timeRemaining)")
                        .font(.largeTitle)
                        .padding()
                        .foregroundStyle(.white)
                        
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
                                    .fill(.white)
                                    .opacity(0.4)
                                    .clipShape(.capsule)
                            }
                    }
                }
                if timeRemaining != 0 && cards.isEmpty == false{
                    ZStack{
                        ForEach(cards, id: \.id) { card in
                            if let index = findIndexOf(card){
                                CardView(card: card) {
                                    withAnimation {
                                        removeCard(at: index)
                                    }
                                } getTry: {
                                    withAnimation {                              
                                        cards.removeLast()
                                        cards.insert(Card(prompt: card.prompt, answer: card.answer), at: 0)
                                    }
                                }
                                .stacked(at: index, in: cards.count)
                                .scaled(at: index, in: cards.count)
                                .allowsHitTesting(!(timeRemaining == 0))
                                .allowsHitTesting(index == cards.count - 1)
                            }
                            
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topTrailing) {
                VStack{
                    HStack{
                        Spacer()
                        
                        Button{
                            showingEditScreen.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                                .frame(height: 60)
                        }
                    }
                }
                .foregroundStyle(.white)
                .font(.largeTitle)
                .padding(.trailing, 30)
                
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
        .onAppear(perform: { resetCards() })
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditView.init)
        
    }
    
    func removeCard(at index: Int) {
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        loadData()
        timeRemaining = 100
        isActive = true
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func findIndexOf(_ card: Card) -> Int? {
        for i in 0..<cards.count {
            if cards[i].id == card.id {
                return i
            }
        }
        return nil
    }
}

#Preview {
    ContentView()
}
