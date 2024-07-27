//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rafiq Rifhan Rosman on 2024/07/11.
//

import SwiftUI


struct ProminentTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(.blue)
    }
}


extension View {
    func prominent() -> some View {
        modifier(ProminentTitleStyle())
    }
}




struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    
    @State private var roundsCounter = 1
    @State private var showResetButton = false
    
    
    struct FlagView: View {
        var text : String
        
        var body: some View {
            Image(text)
                .clipShape(.rect(cornerRadius: 8))
                .shadow(radius: 6)
        }

    }
    
    var body: some View {           
        ZStack {
            LinearGradient(colors: [.purple, .cyan], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the flag")
//                    .font(.largeTitle.weight(.bold))
//                    .foregroundStyle(.white)
                    .prominent()
                    .padding(5)
                    .background(.thinMaterial)
                    .clipShape(.rect(cornerRadius: 8))
                Spacer()
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) {number in
                        Button {
                            //flag was tapped
                            flagTapped(number)
                        } label: {
                            FlagView(text: countries[number])
                        }
                    }
                }
                .padding(50)
                .background(.ultraThinMaterial)
                .cornerRadius(50)
                Spacer()
                
                Text("Current Score: \(currentScore)")
                    .padding(5)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                Spacer()
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(currentScore)")
            }
            .alert("Game Completed!", isPresented: $showResetButton) {
                Button("Start over", action: reset)
            } message: {
                Text("Your total score is \(currentScore)")
            }
            
        }
    }
    
    func flagTapped(_ number: Int) {
        if roundsCounter == 8 {
            showResetButton = true
        }
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        showingScore = true
        roundsCounter += 1
    }
    
    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
        
    }
    
    func reset() {
        currentScore = 0
        roundsCounter = 1
        showingScore = false
    }
    
}

#Preview {
    ContentView()
}
