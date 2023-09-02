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
        }
    }
}

struct GameView: View {
    @StateObject var dataManager = DataManager.shared
    @State var command = ""
    
    //[TODO]: Add func recognize text
    @State private var hpString: String = ""
    @State private var imgName = "DALL-E"
    
    let margin = 20.0
    let radius = 8.0
    
    var body: some View {
        VStack{
            ForEach(dataManager.itemData, id: \.id) { item in
                HeaderView(Int(item.hp.description) ?? 5)
                    .foregroundColor(Color.OasisColors.white)
                    .padding(.bottom, 39)
                    .padding(.horizontal, margin)
                
                StoryView(item.content, imgName)
                
                VStack {
                    ForEach(Array(item.choices.keys.sorted()), id: \.self) { key in
                        VStack {
                            Text("\(key): \(item.choices[key] ?? "")")
                                .onTapGesture {
                                    command = key
                                    print(command)
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.vertical, 16)
                                .padding(.horizontal, margin)
                            Divider()
                        }
                    }
                }
            }
        }
        .onAppear {
            dataManager.loadData()
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
                .frame(maxWidth: .infinity, alignment: .leadingFirstTextBaseline)
            
            Image(img)
                .resizable()
                .scaledToFit()
        }
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: radius)
                .fill(Color.OasisColors.white10))
        .padding(.horizontal, margin)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
