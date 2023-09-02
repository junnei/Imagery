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

struct GameView: View {
    @StateObject var dataManager = DataManager.shared
    @State var command = ""
    
    //[TODO]: Add func recognize text
    @State private var hpString: String = ""
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.Yellow.yellow.color)
            .overlay {
                VStack{
                    ForEach(dataManager.itemData, id: \.id) { item in
                        Text("HP : "+item.hp.description)
                            .speakOnTap("HP : "+item.hp.description)
                        ScrollView {
                            Text(item.content)
                                .speakOnTap(item.content)
                        }
                        Image("DALL-E")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                        List {
                            ForEach(Array(item.choices.keys.sorted()), id: \.self) { key in
                                Text("\(key): \(item.choices[key] ?? "")")
                                    .onTapGesture {
                                        command = key
                                        print(command)
                                    }
                            }
                        }
                        .foregroundColor(.black)
                    }
                    .padding()
                }
                .foregroundColor(Color.DarkGreen.darkGreen.color)
            }
            .padding()
            .onAppear {
                dataManager.loadData()
            }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
