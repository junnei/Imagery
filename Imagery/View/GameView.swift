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
    @StateObject var gameManager = GameManager.shared
    @State var command = ""
    
    //[TODO]: Add func recognize text
    @State private var hpString: String = ""
    @State var pressed: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(gameManager.healthState == .drop ? .red : (gameManager.healthState == .heal ? .blue : Color.OasisColors.yellow))
            .overlay {
                VStack{
                    if (dataManager.dataList.count > 0) {
                        let lastIndex = dataManager.dataList.count - 1
                        Text("HP : \(dataManager.dataList[lastIndex].hp.description)")
                        Text(dataManager.dataList[lastIndex].content)
                        AsyncImage(url: URL(string: dataManager.dataList[lastIndex].dall)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 300)
                        
                        HStack {
                            if let a = dataManager.dataList[lastIndex].choices["a"] {
                                Button(a) {
                                    if (dataManager.pressed == false) {
                                        let _ = print("a")
                                        dataManager.pressed = true
                                        Task {
                                            await dataManager.loadData("a")
                                        }
                                    }
                                }
                            }
                            if let b = dataManager.dataList[lastIndex].choices["b"] {
                                Button(b) {
                                    if (dataManager.pressed == false) {
                                        let _ = print("b")
                                        dataManager.pressed = true
                                        Task {
                                            await dataManager.loadData("b")
                                        }
                                    }
                                }
                            }
                            
                            if let c = dataManager.dataList[lastIndex].choices["c"] {
                                Button(c) {
                                    if (dataManager.pressed == false) {
                                        let _ = print("c")
                                        dataManager.pressed = true
                                        Task {
                                            await dataManager.loadData("c")
                                        }
                                    }
                                }
                            }
                        }
                        .background(dataManager.pressed ? .gray : .yellow )
                    }
                    /*
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
                    .padding()*/
                }
                .foregroundColor(Color.OasisColors.darkGreen)
            }
            .padding()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
