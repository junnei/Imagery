//
//  ContentView.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import SwiftUI

struct ContentView: View {
    @StateObject var gameManager = GameManager.shared
    @State private var isLoading = false
    var body: some View {
        ZStack {
            switch gameManager.healthState {
            case .normal:
                Color.OasisColors.darkGreen
                    .ignoresSafeArea()
            case .drop:
                Color.OasisColors.error
                    .ignoresSafeArea()
            case .heal:
                Color.OasisColors.success
                    .ignoresSafeArea()
            case .fail:
                Color.OasisColors.badEnding
                    .ignoresSafeArea()
            case .success:
                Color.OasisColors.darkGreen
                    .ignoresSafeArea()
            }
            
            switch gameManager.gameState {
            case .initial:
                StartView()
            case .ownStory:
                OwnStoryView()
            case .randomStory:
                RandomStoryView()
            case .playing, .result:
                GameView()
            case .storyHistory:
                HistoryView()
            case .illustCollection:
                OverallAlbumView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
