//
//  ContentView.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import SwiftUI

enum gameState{
    case initial
    case playing
    case result
    case history
}


struct ContentView: View {
    @StateObject var gameManager = GameManager.shared
    @State private var isLoading = false
    var body: some View {
        ZStack {
            Color.OasisColors.darkGreen70
                .ignoresSafeArea()
            switch gameManager.gameState {
            case .initial:
                StartView()
            case .playing, .result, .history:
                GameView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
