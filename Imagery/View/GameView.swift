//
//  GameView.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import SwiftUI
import AVFoundation

struct GameView: View {
    @StateObject var dataManager = DataManager.shared
    @State var command = ""
    let speechSynthesizer = AVSpeechSynthesizer() // AVSpeechSynthesizer 인스턴스 생성

    // 텍스트를 읽어주는 함수
    func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR") // 한국어 음성으로 설정
        utterance.rate = 0.5 // 음성 속도 조절 (1.0이 기본값)
        utterance.pitchMultiplier = 1.0 // 음성 높낮이 조절 (1.0이 기본값)
        speechSynthesizer.speak(utterance)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.themeyellow)
            .overlay {
                VStack{
                    ForEach(dataManager.itemData, id: \.id) { item in
                        Text("HP : "+item.HP.description)
                            .onTapGesture {
                                speakText("HP: \(item.HP)")
                            }
                        Text(item.content)
                            .onTapGesture {
                                speakText(item.content)
                            }
                        Spacer()
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
                .foregroundColor(.darkGreen)
            }
            .padding()
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
