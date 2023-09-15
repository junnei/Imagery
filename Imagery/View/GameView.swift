//
//  GameView.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import SwiftUI
import Combine

//TODO: 파일 따로
enum HeaderItem {
    case back
    case house
    case photo
    case hp
    case heart
    case heartFill
    case xmark
    
    var label: String {
        switch self {
        case .back:
            return "chevron.left"
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
    
    //[TODO]: Add func recognize text
    @State private var showImageOnly = false
    @State private var selectedKey = ""
    
    let margin = 20.0
    let radius = 8.0
    
    @State private var background: Color = Color.OasisColors.darkGreen
    
    var body: some View {
        ZStack {
            gameManager.background.ignoresSafeArea()
            
            if showImageOnly {
                IllustView(dataManager.dataList.last!.dall)
                    .zIndex(1)
            }
            
            VStack{
                if dataManager.isLoading {
                    Spacer()
                    
                    VStack(spacing: 24) {
                        Text("로딩 중입니다...")
                            .font(.headline)
                            .foregroundColor(Color.OasisColors.yellow)
                            .accessibilityLabel("로딩 중 입니다")
                            .accessibilityIdentifier("content")
                        
                        ProgressView()
                            .tint(Color.OasisColors.yellow)
                    }
                    
                    Spacer()
                }
                else {
                    let lastIndex = dataManager.dataList.count - 1
                    if (lastIndex >= 0) {
                        HeaderView(Int(dataManager.dataList[lastIndex].hp))
                            .foregroundColor(Color.OasisColors.white)
                            .padding(.bottom, 36)
                            .padding(.top, 61)
                            .padding(.horizontal, margin)
                        
                        StoryView(dataManager.dataList[lastIndex].content, dataManager.dataList[lastIndex].dall)
                            .accessibilityLabel("\(dataManager.dataList[lastIndex].content)")
                            .accessibilityIdentifier("content")
                            .padding(.bottom, 34)
                        
                        VStack(spacing: 0) {
                            VStack {
                                if let a = dataManager.dataList[lastIndex].choices["a"] {
                                    Button {
                                        if (dataManager.pressed == false) {
                                            dataManager.pressed = true
                                            Task {
                                                await dataManager.loadData("a")
                                            }
                                        }
                                        selectedKey = "a"
                                    } label: {
                                        Text(a)
                                            .foregroundColor(dataManager.pressed ? setOptionTextColor("a") : Color.OasisColors.white)
                                            .padding(.vertical, 16)
                                            .padding(.top, 4)
                                            .padding(.horizontal, margin)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .accessibilityLabel(a)
                                    .accessibilityIdentifier("choice1")
                                }
                                Divider()
                                    .overlay(Color.OasisColors.white20)
                            }
                            .background(dataManager.pressed ? setOptionBackground("a") : .clear)
                            
                            VStack {
                                if let b = dataManager.dataList[lastIndex].choices["b"] {
                                    Button {
                                        if (dataManager.pressed == false) {
                                            dataManager.pressed = true
                                            Task {
                                                await dataManager.loadData("b")
                                            }
                                        }
                                        selectedKey = "b"
                                    } label: {
                                        Text(b)
                                            .foregroundColor(dataManager.pressed ? setOptionTextColor("b") : Color.OasisColors.white)
                                            .padding(.vertical, 16)
                                            .padding(.top, 4)
                                            .padding(.horizontal, margin)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .accessibilityLabel(b)
                                    .accessibilityIdentifier("choice2")
                                }
                                
                                Divider()
                                    .overlay(Color.OasisColors.white20)
                            }
                            .background(dataManager.pressed ? setOptionBackground("b") : .clear)
                            
                            VStack {
                                if let c = dataManager.dataList[lastIndex].choices["c"] {
                                    Button {
                                        if (dataManager.pressed == false) {
                                            dataManager.pressed = true
                                            Task {
                                                await dataManager.loadData("c")
                                            }
                                        }
                                        selectedKey = "c"
                                    } label: {
                                        Text(c)
                                            .foregroundColor(dataManager.pressed ? setOptionTextColor("c") : Color.OasisColors.white)
                                            .padding(.vertical, 16)
                                            .padding(.top, 4)
                                            .padding(.horizontal, margin)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .accessibilityLabel(c)
                                    .accessibilityIdentifier("choice3")
                                }
                                Divider()
                                    .overlay(Color.OasisColors.white20)
                            }
                            .background(dataManager.pressed ? setOptionBackground("c") : .clear)
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 59)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    func setHP(_ hp: Int) -> String {
        var hpStatus = ""
        
        for _ in 0..<hp {
            hpStatus += HeaderItem.heartFill.label
        }
        for _ in hp..<5 {
            hpStatus += HeaderItem.heart.label
        }
        
        return hpStatus
    }
    
    func setOptionTextColor(_ key: String) -> Color {
         if key == selectedKey {
             return Color.OasisColors.darkGreen
         } else {
             return Color.OasisColors.white
         }
     }

     func setOptionBackground(_ key: String) -> Color {
         if key == selectedKey {
             return Color.OasisColors.yellow
         } else {
             return Color.clear
         }
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
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(width: 36, height: 36)
                    .padding(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("HP \(setHP(hp))")
            .font(.callout)
            .fontWeight(.semibold)
            .fixedSize()
            .padding(.vertical, 4)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.OasisColors.white10)
            )
            .frame(maxWidth: .infinity, alignment: .center)
            .accessibilityLabel("체력 : \(hp)")
            .accessibilityIdentifier("HP")
            
            Button {
                GameManager.shared.gameState = .inIllustCollection
            } label: {
                Image(systemName: HeaderItem.photo.label)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(width: 36, height: 36)
                    .padding(3)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

private extension GameView {
    
    @ViewBuilder
    func StoryView(_ content: String, _ imgURL: String) -> some View {
        ScrollView {
            if imgURL != "" {
                AsyncImage(url: URL(string: imgURL)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                        .opacity(0.5)
                        .overlay {
                            ProgressView()
                                .tint(Color.OasisColors.yellow)
                        }
                }
                .frame(width: 300, height: 300)
                .accessibilityLabel("이미지")
                .accessibilityIdentifier("Image")
                .onTapGesture {
                    self.showImageOnly = true
                }
                .padding(.bottom, 12)
            }
            
            HStack {
                Text(content)
                    .font(.headline)
                    .lineSpacing(14)
                    .foregroundColor(Color.OasisColors.white)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
                //.frame(maxWidth: .infinity, alignment: .leadingFirstTextBaseline)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: radius)
                .fill(Color.OasisColors.white10))
        .padding(.horizontal, margin)
    }
}

private extension GameView {
    
    @ViewBuilder
    func IllustView(_ imgURL: String) -> some View {
        ZStack {
            Color.OasisColors.darkGreen.opacity(0.9)
            
            AsyncImageView(url: URL(string: imgURL)!)
            
            VStack(spacing: 44) {
                Button {
                    self.showImageOnly = false
                } label: {
                    Image(systemName: HeaderItem.xmark.label)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .frame(width: 36, height: 36)
                        .foregroundColor(Color.OasisColors.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                    .padding(.trailing, margin)
                    .padding(.bottom, 3)
                
                /*
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
                */
                Spacer()
                    .frame(width: 390, height: 390)
                
                Text("일러스트에 손을 가져다대어 그림을 느껴보세요.\n현재 누르고 있는 이미지의 색의 명도에 따라 밝을수록 진동이 세게 울려요.")
                    .font(.headline)
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
