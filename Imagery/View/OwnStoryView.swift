//
//  OwnStoryView.swift
//  Imagery
//
//  Created by Nayeon Kim on 2023/09/03.
//

import SwiftUI
import AVFoundation

class AudioRecorderManger: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    //음성메모 녹음 관련 프로퍼티
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording = false
    
    // 음성메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var isPaused = false
    
    // 음성메모된 데이터
    @Published var recordedFiles = [URL]()
    
}

// MARK: - 음성메모 녹음 관련 메서드
extension AudioRecorderManger {
    func startRecording() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("inputAudio.m4a")
        self.recordedFiles.append(fileURL)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true
        } catch {
            print("녹음 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        self.isRecording = false
        
        let sourceURL = getDocumentsDirectory().appendingPathComponent("inputAudio.m4a")
        //let destinationURL = getDocumentsDirectory().appendingPathComponent("recordedAudio.m4a")
        
        do {
            // 녹음이 끝난 후 파일 다
            //try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
            //print("저장 파일 위치: \(destinationURL)")
            self.recordedFiles.append(sourceURL)
            Task {
                await DataManager.shared.loadSpeech(sourceURL)
            }
        } catch {
            print("Save recorded file error: \(error.localizedDescription)")
        }
    }
    
    func loadFileFromLocalPath(_ localFilePath: String) ->Data? {
       return try? Data(contentsOf: URL(fileURLWithPath: localFilePath))
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    

}
// MARK: 음성메모 재생 관련 메서드
extension AudioRecorderManger {
    func startPlaying(recordingURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            self.isPlaying = true
            self.isPaused = false
        } catch {
            print("재생 중 오류 발생:")
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        self.isPlaying = false
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
}



struct OwnStoryView: View {
    @StateObject var audioRecorder = AudioRecorderManger()
    
    let title = "만들고 싶은 이야기를\n적어주세요"
    
    let margin = 20.0
    let radius = 8.0
    
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
                /*
                Button(action: {
                    if audioRecorder.isRecording {
                        audioRecorder.stopRecording()
                    } else {
                        audioRecorder.startRecording()
                    }
                }) {
                    Text(audioRecorder.isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                        .background(audioRecorder.isRecording ? Color.red : Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                
                if (audioRecorder.recordedFiles.count > 0) {
                    Text("Recording saved at: \(audioRecorder.recordedFiles[0].path)")
                        .padding()
                }*/
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
