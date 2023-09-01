//
//  DataManager.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import Foundation

class DataManager : ObservableObject {
    static let shared = DataManager()
    private init() {}
    
    @Published var itemData: [Item] = loadJson("Instruction.json")
}
