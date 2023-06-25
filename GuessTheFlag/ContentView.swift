//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nowroz Islam on 25/5/23.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var score = 0
    @State private var turn = 1
    
    @State private var showingFinalScore = false
    @State private var finalScoreTitle = ""
    @State private var finalScoreMessage = ""
    
    @State private var spinFlags = Array(repeating: false, count: 3)
    @State private var fadeFlags = Array(repeating: false, count: 3)
    @State private var scaleFlags = Array(repeating: false, count: 3)
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(stops: [
                Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                Gradient.Stop(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ]), center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(Font.subheadline.weight(Font.Weight.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            
                            withAnimation(.easeIn(duration: 0.5)) {
                                spinFlags[number] = true
                                
                                for i in 0..<fadeFlags.count {
                                    if i != number {
                                        fadeFlags[i] = true
                                        scaleFlags[i] = true
                                    }
                                }
                            }
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .shadow(radius: 5)
                                .opacity(fadeFlags[number] ? 0.5 : 1.0)
                                .scaleEffect(scaleFlags[number] ? 0.5 : 1.0)
                                .rotation3DEffect(
                                    .degrees(spinFlags[number] ? 360 : 0),
                                    axis: (x:0, y: 1, z: 0)
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                VStack {
                    Text("Turn: \(turn)/8")
                        .foregroundColor(.white)
                    
                    Text("Score: \(score)")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") {
                continueGame()
            }
        } message: {
            Text(scoreMessage)
        }
        .alert(finalScoreTitle, isPresented: $showingFinalScore) {
            Button("Restart") {
                restartGame()
            }
        } message: {
            Text(finalScoreMessage)
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 2
            
            scoreMessage = "Your score is \(score)."
        } else {
            scoreTitle = "Wrong"
            score = max(0, score - 1)
            
            scoreMessage = """
                        That's the flag of \(countries[number]).
                        Your score is \(score).
                        """
        }
        
        if turn == 8 {
            finalScoreTitle = "Game Over"
            finalScoreMessage = "Your final score is \(score)."
            
            showingFinalScore = true
        } else {
            showingScore = true
        }
    }
    
    func continueGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        turn += 1
        resetFlags()
    }
    
    func restartGame() {
        turn = 1
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        resetFlags()
    }
    
    func resetFlags() {
        spinFlags = Array(repeating: false, count: 3)
        fadeFlags = Array(repeating: false, count: 3)
        scaleFlags = Array(repeating: false, count: 3)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
