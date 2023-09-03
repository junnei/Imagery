//
//  GameManager.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import Foundation

enum gameState{
    case initial
    case playing
    case result
    case storyHistory
    case illustCollection
    case ownStory
}

enum healthState{
    case normal
    case drop
    case heal
    case fail
    case success
}

class GameManager : ObservableObject {
    static let shared = GameManager()
    private init() {}
    
    @Published var gameState: gameState = .initial
    @Published var healthState: healthState = .normal
}
