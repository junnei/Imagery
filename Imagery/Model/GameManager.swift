//
//  GameManager.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import Foundation
import AVFoundation

class GameManager : ObservableObject {
    static let shared = GameManager()
    let speechSynthesizer = AVSpeechSynthesizer()
    private init() {}
    
    @Published var gameState: gameState = .initial
}
