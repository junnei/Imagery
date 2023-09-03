//
//  StartView.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import SwiftUI

enum ButtonType {
    case recentStory
    case ownStory
    case randomStory
    case storyHistory
    case illustCollection
    
    var label: String {
        switch self {
        case .recentStory:
            return "최근 이야기 진행하기"
        case .ownStory:
            return "나의 이야기 만들기"
        case .randomStory:
            return "랜덤 이야기 만들기"
        case .storyHistory:
            return "나의 이야기\n기록"
        case .illustCollection:
            return "일러스트\n모음"
        }
    }
}

struct StartView: View {
    @StateObject var dataManager = DataManager.shared
    let appLogo = "AppLogo"
    let margin = 20.0
    let radius = 12.0
    let gap = 27.0
    
    @State private var isFirstPlay = false
    
    var body: some View {
        VStack {
            Image(appLogo)
                .resizable()
                .scaledToFit()
                .accessibilityLabel("appLogo Imagery")
                .accessibilityIdentifier("appLogo")
                .onTapGesture {
                    DataManager.shared.resetData()
                }
            
            //FIXME: enum으로 처리
            if isFirstPlay {
                VStack(spacing: gap) {
                    PlayButton(buttonType: .ownStory)
                        .accessibilityLabel(ButtonType.ownStory.label)
                        .accessibilityIdentifier("ownStory")
                    PlayButton(buttonType: .randomStory)
                        .accessibilityLabel(ButtonType.randomStory.label)
                        .accessibilityIdentifier("randomStory")
                }
                .padding(.top, 83)
            } else {
                VStack(spacing: gap) {
                    PlayButton(buttonType: .recentStory)
                        .accessibilityLabel(ButtonType.recentStory.label)
                        .accessibilityIdentifier("recentStory")
                        .disabled(dataManager.dataList.count > 0 ? false : true)
                    PlayButton(buttonType: .ownStory)
                        .accessibilityLabel(ButtonType.ownStory.label)
                        .accessibilityIdentifier("ownStory")
                    PlayButton(buttonType: .randomStory)
                        .accessibilityLabel(ButtonType.randomStory.label)
                        .accessibilityIdentifier("randomStory")
                    HStack(spacing: gap) {
                        PlayButton(buttonType: .storyHistory)
                            .accessibilityLabel(ButtonType.storyHistory.label)
                            .accessibilityIdentifier("storyHistory")
                        PlayButton(buttonType: .illustCollection)
                            .accessibilityLabel(ButtonType.illustCollection.label)
                            .accessibilityIdentifier("illustCollection")
                    }
                }
                .padding(.top, 53)
            }
            Spacer()
        }
        .padding(margin)
        .onAppear {
            isFirstPlay = dataManager.dataList.isEmpty
        }
    }
}

struct PlayButton: View {
    let buttonType: ButtonType
    
    let gap = 27.0
    let radius = 12.0
    
    @State private var isPressed = false
    
    var body: some View {
        Button {
            self.isPressed.toggle()
            //FIXME: 버튼에 따라 perform 상세 수정
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                switch buttonType {
                case .recentStory :
                    GameManager.shared.gameState = .playing
                case .randomStory :
                    GameManager.shared.gameState = .randomStory
                    /*
                    DataManager.shared.isLoading = true
                    GameManager.shared.gameState = .playing
                    Task {
                        await DataManager.shared.loadData("")
                    }*/
                case .ownStory :
                    GameManager.shared.gameState = .ownStory
                case .storyHistory :
                    GameManager.shared.gameState = .storyHistory
                case .illustCollection :
                    GameManager.shared.gameState = .illustCollection
                }
            }
        } label: {
            Text(buttonType.label)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(SetButtonLabelColor(buttonType, isPressed))
                .fixedSize()
                .padding(.vertical, gap)
                .frame(maxWidth: .infinity)
                .background(
                    SetButtonBackground(buttonType, isPressed)
                )
        }
    }
    func SetButtonLabelColor(_ buttonType: ButtonType, _ isPressed: Bool) -> Color {
        if (buttonType == .recentStory) {
            if DataManager.shared.dataList.count > 0 {
                return Color.OasisColors.darkGreen
            } else {
                return Color.gray
            }
        }
        else {
            if (isPressed) {
                return Color.OasisColors.darkGreen
            } else {
                return Color.OasisColors.white
            }
        }
    }
    
    func SetButtonBackground (_ buttonType: ButtonType, _ isPressed: Bool) -> some View {
        if isPressed {
            let background = RoundedRectangle(cornerRadius: radius)
                .fill(Color.OasisColors.yellow)
            return AnyView(background)
        } else if buttonType == .recentStory {
            let background = RoundedRectangle(cornerRadius: radius)
                .fill(Color.OasisColors.yellow30)
            return AnyView(background)
        } else {
            let background = RoundedRectangle(cornerRadius: radius)
                .stroke(Color.OasisColors.white)
                .background(Color.OasisColors.white10)
            
            return AnyView(background)
        }
    }
    
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
