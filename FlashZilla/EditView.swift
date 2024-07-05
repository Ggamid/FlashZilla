//
//  EditView.swift
//  FlashZilla
//
//  Created by Gamıd Khalıdov on 05.07.2024.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    @State private var cards = [Card]()
    
    
    var body: some View {
        
        NavigationStack{
            List{
                Section{
                    TextField("Question", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card"){
                        addCard()
                    }
                }
                Section{
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading){
                            Text(cards[index].prompt)
                                .font(.title)
                            Text(cards[index].answer)
                                .foregroundStyle(.gray)
                        }
                    }
                    .onDelete(perform: deleteCard)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done"){
                        dismiss()
                    }
                }
                
            }
            .onAppear(perform: loadData)
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func deleteCard(at index: IndexSet){
        cards.remove(atOffsets: index)
        saveData()
    }
    
    func saveData(){
        if let data = try? JSONEncoder().encode(cards){
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func addCard(){
        let prompt = newPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let answer = newAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard prompt.isEmpty == false && answer.isEmpty == false else { return }
        
        let card = Card(prompt: prompt, answer: answer)
        cards.insert(card, at: 0)
        
        newPrompt = ""
        newAnswer = ""
        
        saveData()
        
    }
}

#Preview {
    EditView()
}
