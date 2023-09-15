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

struct Item: Decodable {
    var dall: String
    var content: String
    var hp: Int
    var state: String
    var choices: [String: String]
}
