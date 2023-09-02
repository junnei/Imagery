//
//  Color.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import SwiftUI

extension Color {
    enum DarkGreen: OasisColors {
        case darkGreen
        case darkGreen70
        case darkGreen40
        case darkGreen30
        case darkGreen20
        case darkGreen10
        
        var color: Color {
            switch self {
            case .darkGreen:
                return Color("DarkGreen")
            case .darkGreen70:
                return Color("DarkGreen70")
            case .darkGreen40:
                return Color("DarkGreen40")
            case .darkGreen30:
                return Color("DarkGreen30")
            case .darkGreen20:
                return Color("DarkGreen20")
            case .darkGreen10:
                return Color("DarkGreen10")
            }
        }
    }
    
    enum Yellow: OasisColors {
        case yellow
        case yellow70
        case yellow40
        case yellow30
        case yellow20
        case yellow10
        
        var color: Color {
            switch self {
            case .yellow:
                return Color("Yellow")
            case .yellow70:
                return Color("Yellow70")
            case .yellow40:
                return Color("Yellow40")
            case .yellow30:
                return Color("Yellow30")
            case .yellow20:
                return Color("Yellow20")
            case .yellow10:
                return Color("Yellow10")
            }
        }
    }
    
    enum White: OasisColors {
        case white
        case white90
        case white80
        case white70
        case white60
        case white50
        case white40
        case white30
        case white20
        case white10
        
        var color: Color {
            switch self {
            case .white:
                return Color("White")
            case .white90:
                return Color("White90")
            case .white80:
                return Color("White80")
            case .white70:
                return Color("White70")
            case .white60:
                return Color("White60")
            case .white50:
                return Color("White50")
            case .white40:
                return Color("White40")
            case .white30:
                return Color("White30")
            case .white20:
                return Color("White20")
            case .white10:
                return Color("White10")
            }
        }
    }
}

protocol OasisColors {
    var color: Color { get }
}
