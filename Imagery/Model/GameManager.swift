//
//  GameManager.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import Foundation

class GameManager : ObservableObject {
    static let shared = GameManager()
    private init() {}
    
    @Published var gameState: gameState = .initial
}
