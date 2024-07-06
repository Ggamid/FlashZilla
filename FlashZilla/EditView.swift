//
//  EditView.swift
//  FlashZilla
//
//  Created by Gamıd Khalıdov on 05.07.2024.
//

import SwiftUI
import SwiftData

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    

    @Environment(\.modelContext) var modelContext
    @Query var cards: [Card]
    
    
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
        }
    }

    
    func deleteCard(at index: IndexSet){
        for i in index {
            modelContext.delete(cards[i])
        }
    }
    
    func addCard(){
        let prompt = newPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let answer = newAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard prompt.isEmpty == false && answer.isEmpty == false else { return }
        
        let card = Card(prompt: prompt, answer: answer)
        modelContext.insert(card)
        
        newPrompt = ""
        newAnswer = ""
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Card.self, configurations: config)
    
    for _ in 1..<10 {
        let user = Card(prompt: "somrPrompt", answer: "someAnswer")
        container.mainContext.insert(user)
    }
    
    return EditView()
        .modelContainer(container)
}
