//
//  GameView.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import SwiftUI
import AVFoundation
import Combine

extension Text {
    func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR") // 한국어 음성으로 설정
        utterance.rate = 0.5 // 음성 속도 조절 (1.0이 기본값)
        utterance.pitchMultiplier = 1.0 // 음성 높낮이 조절 (1.0이 기본값)
        GameManager.shared.speechSynthesizer.speak(utterance)
    }
    
    func speakOnTap(_ text: String) -> some View {
        return self.onTapGesture {
            speakText(text)
        }
    }
}

enum HeaderItem {
    case house
    case photo
    case hp
    case heart
    case heartFill
    case xmark
    
    var label: String {
        switch self {
        case .house:
            return "house.fill"
        case .photo:
            return "photo.fill"
        case .hp:
            return "HP"
        case .heart:
            return "♡"
        case .heartFill:
            return "♥︎"
        case .xmark:
            return "xmark.circle.fill"
        }
    }
}

struct GameView: View {
    @StateObject var dataManager = DataManager.shared
    @StateObject var gameManager = GameManager.shared
    @State var command = ""
    
    //[TODO]: Add func recognize text
    @State private var hpString: String = ""
    @State private var imgName = "DALL-E"
    @State private var showImageOnly = false
    
    let margin = 20.0
    let radius = 8.0
    
    var body: some View {
        ZStack {
            //TODO: 스토리 진행 상황별 배경색 변경
            if showImageOnly {
                IllustView(imgName)
                    .zIndex(1)
            }
            
            VStack{
                let lastIndex = dataManager.dataList.count - 1
                if (lastIndex > 0) {
                    HeaderView(Int(dataManager.dataList[lastIndex].hp) ?? 5)
                        .foregroundColor(Color.OasisColors.white)
                        .padding(.bottom, 39)
                        .padding(.horizontal, margin)
                    
                    StoryView(dataManager.dataList[lastIndex].content, imgName)
                    
                    VStack {
                        VStack {
                            if let a = dataManager.dataList[lastIndex].choices["a"] {
                                Button(a) {
                                    if (dataManager.pressed == false) {
                                        dataManager.pressed = true
                                        Task {
                                            await dataManager.loadData("a")
                                        }
                                    }
                                }
                            }
                            Divider()
                            if let b = dataManager.dataList[lastIndex].choices["b"] {
                                Button(b) {
                                    if (dataManager.pressed == false) {
                                        dataManager.pressed = true
                                        Task {
                                            await dataManager.loadData("b")
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            if let c = dataManager.dataList[lastIndex].choices["c"] {
                                Button(c) {
                                    if (dataManager.pressed == false) {
                                        dataManager.pressed = true
                                        Task {
                                            await dataManager.loadData("c")
                                        }
                                    }
                                }
                            }
                            Divider()
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.OasisColors.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, margin)
                    }
                }
            }
            .padding()
        }
    }
    func setHP(_ hp: Int) -> String {
        var hpStatus = ""
        
        for _ in 1...hp {
            hpStatus += HeaderItem.heartFill.label
        }
        for _ in (hp + 1)...5 {
            hpStatus += HeaderItem.heart.label
        }
        
        return hpStatus
    }
}


private extension GameView {
    
    @ViewBuilder
    func HeaderView(_ hp: Int) -> some View {
        HStack {
            Button {
                GameManager.shared.gameState = .initial
            } label: {
                Image(systemName: HeaderItem.house.label)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("HP \(setHP(hp))")
            .font(.callout)
            .speakOnTap("HP: \(String(hp))")
            .fixedSize()
            .padding(.vertical, 4)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.OasisColors.white10)
            )
            .frame(maxWidth: .infinity, alignment: .center)
            
            Button {
                //TODO: 갤러리 뷰로 이동
            } label: {
                Image(systemName: HeaderItem.photo.label)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

private extension GameView {
    
    @ViewBuilder
    func StoryView(_ content: String, _ img: String) -> some View {
        ScrollView {
            Text(content)
                .speakOnTap(content)
                .font(.headline)
                .foregroundColor(Color.OasisColors.white)
                .frame(maxWidth: .infinity, alignment: .leadingFirstTextBaseline)
            
            Image(img)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    self.showImageOnly = true
                }
        }
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: radius)
                .fill(Color.OasisColors.white10))
        .padding(.horizontal, margin)
    }
}

private extension GameView {
    
    @ViewBuilder
    func IllustView(_ img: String) -> some View {
        ZStack {
            Color.OasisColors.darkGreen.opacity(0.9)
            
            VStack(spacing: 44) {
                Button {
                    self.showImageOnly = false
                } label: {
                    Image(systemName: HeaderItem.xmark.label)
                        .fontWeight(.bold)
                        .foregroundColor(Color.OasisColors.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                    .padding(.trailing, margin)
                    .padding(.bottom, 3)
                
                Text("일러스트 제목")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.OasisColors.darkGreen)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.OasisColors.yellow10)
                    )
                    .padding(.horizontal, 10)
                
                Image(img)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        Rectangle()
                    .stroke(
                        Color.OasisColors.yellow,
                        lineWidth: 8
                    )
                    )
                    .padding(8)
                
                Text("일러스트에 손을 가져다대어 그림을 느껴보세요")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.OasisColors.darkGreen)
                    .padding(6)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.OasisColors.yellow40)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                Color.OasisColors.yellow
                                    )
                            )
                    )
                    .padding(.horizontal, margin)
            }
        }
        .ignoresSafeArea()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
