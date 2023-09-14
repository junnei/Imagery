//
//  OwnStoryView.swift
//  Imagery
//
//  Created by Nayeon Kim on 2023/09/03.
//

import SwiftUI
import AVFoundation

struct OwnStoryView: View {
    /*
    // Create an audio session
    let session = AVAudioSession.sharedInstance()

    // Set the audio session category and mode
    try session.setCategory(.playAndRecord, mode: .default)

    // Activate the audio session
    try session.setActive(true)

    // Create an audio recorder
    let recorder = try AVAudioRecorder(url: URL(string: "./recording.wav")!, settings: [:])
    */
    let title = "만들고 싶은 이야기를\n적어주세요"
    
    let margin = 20.0
    let radius = 8.0
    var isRecording: Bool = false
    
    @State private var text = ""
    
    var body: some View {
        ZStack {
            Color.OasisColors.darkGreen
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Button {
                    GameManager.shared.gameState = .initial
                } label: {
                    Image(systemName: HeaderItem.back.label)
                        .foregroundColor(Color.OasisColors.white)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding(.leading, 8)
                        .padding(.bottom, 24)
                }
                
                Text(title)
                    .font(.system(size: 26))
                    .fontWeight(.bold)
                    .foregroundColor(Color.OasisColors.white)
                    .padding(.horizontal, margin)
                    .padding(.bottom, 36)
                
                StoryInputView()
                Button("Record") {/*
                    if isRecording == false {
                        recorder.record()
                    } else {
                        recorder.stop()
                    }*/
                }
                NextButton()
            }
        }
    }
    
    func setTextColor(_ text: String) -> Color {
        if text.isEmpty {
            return Color.OasisColors.white80
        } else {
            return Color.OasisColors.darkGreen
        }
    }
    
    func setTextBackground(_ text: String) -> Color {
        if text.isEmpty {
            return Color.OasisColors.white10
        } else {
            return Color.OasisColors.white90
        }
    }
    
    func setButtonLabelColor(_ text: String) -> Color {
        if text.isEmpty {
            return Color.OasisColors.darkGreen40
        } else {
            return Color.OasisColors.darkGreen
        }
    }
    
    func setButtonBackgroundColor(_ text: String) -> Color {
        if text.isEmpty {
            return Color.OasisColors.yellow30
        } else {
            return Color.OasisColors.yellow
        }
    }
}

private extension OwnStoryView {
    
    @ViewBuilder
    func StoryInputView() -> some View {
        ZStack {
            if text.isEmpty {
                Text("이야기를 문장 형태로 자세히 입력하세요.")
                    .font(.headline)
                    .foregroundColor(Color.OasisColors.white80)
                    .padding(26)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
            }
            
            TextEditor(text: $text)
                .font(.headline)
                .lineSpacing(14)
                .padding(18)
                .frame(maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.OasisColors.white90)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(setTextBackground(text)
                                     )
                        )
                )
                .foregroundColor(setTextColor(text))
                .padding(.horizontal, margin)
                .padding(.bottom, 73)
        }
    }
}

private extension OwnStoryView {
    
    @ViewBuilder
    func NextButton() -> some View {
        Button {
            DataManager.shared.isLoading = true
            GameManager.shared.gameState = .playing
            Task {
                await DataManager.shared.loadData(text)
                await DataManager.shared.loadSummary(text)
            }
        } label: {
            Text("다음")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(setButtonLabelColor(text))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(setButtonBackgroundColor(text))
                    )
        }
        .disabled(text.isEmpty)
        .padding(.horizontal, 20)
    }
}

struct OwnStoryView_Previews: PreviewProvider {
    static var previews: some View {
        OwnStoryView()
    }
}
