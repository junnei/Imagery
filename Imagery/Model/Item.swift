//
//  Item.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import Foundation

struct Instruction: Decodable {
    var id: Int
    var hp: Int
    var theme: String
    var background: String
    var content: String
    var choices: [String: String]
    var state: String
}

struct InstructionResponse: Decodable {
   let instruction: [Instruction]
}

/*
struct Item: Codable, Identifiable {
    var id: Int
    var hp: Int
    var theme: String
    var background: String
    var content: String
    var choices: [String: String]
    var state: String
    
    enum CodingKeys: Int, CodingKey {
        case id = 0
        case hp
        case theme
        case background
        case content
        case choices
        case state
    }
}

func loadJson<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("\(filename) not found.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Could not load \(filename): \(error)")
    }
    
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Unable to parse \(filename): \(error)")
    }
}

*/
