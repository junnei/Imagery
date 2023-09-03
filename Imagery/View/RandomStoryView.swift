//
//  RandomStoryView.swift
//  Imagery
//
//  Created by Nayeon Kim on 2023/09/03.
//

import SwiftUI

struct RandomStoryView: View {
    let margin = 20.0
    
    @State private var isPressed = false
    @State private var isContentDelivered = false
    
    var body: some View {
        ZStack {
            Color.OasisColors.darkGreen
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Button {
                    
                } label: {
                    Image(systemName: HeaderItem.back.label)
                        .foregroundColor(Color.OasisColors.white)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding(.leading, 8)
                        .padding(.bottom, 24)
                }
                
                Text(setTitle(isContentDelivered))
                    .font(.system(size: 26))
                    .fontWeight(.bold)
                    .foregroundColor(Color.OasisColors.white)
                    .padding(.horizontal, margin)
                    .padding(.bottom, 36)
                
                Spacer()
                
                if !isContentDelivered {
                    RandomButton()
                        .padding(.horizontal, margin)
                } else {
                    ContentBox()
                        .padding(.horizontal, margin)
                }
                
                Spacer()
                
                BottomButtons()
                    .padding(.horizontal, margin)
            }
        }
    }
    
    func setTitle(_ isSet: Bool) -> String {
        if !isSet {
            return "당신의 이야기 소재를\n랜덤으로 뽑아보세요"
        } else {
            return "아래 소재가 나왔어요"
        }
    }
    
    func setButtonLabelColor(_ isPressed: Bool) -> Color {
        if isPressed {
            return Color.OasisColors.darkGreen
        } else {
            return Color.OasisColors.white
        }
    }
    
    func setButtonBackground(_ isPressed: Bool) -> some View {
        if !isPressed {
            let background = RoundedRectangle(cornerRadius: 12)
                .stroke(Color.OasisColors.white)
                .background(
                    Color.OasisColors.white10
                )
            
            return AnyView(background)
        } else {
            let backgroud = RoundedRectangle(cornerRadius: 12)
                .fill(Color.OasisColors.yellow)
            
            return AnyView(backgroud)
        }
    }
    
    func setButtonsOpacity(_ isSet: Bool) -> CGFloat {
        if isSet {
            return 1.0
        } else {
            return 0.0
        }
    }
}

private extension RandomStoryView {
    
    @ViewBuilder
    func RandomButton() -> some View {
        Button {
            isPressed = true
        } label: {
            Text("랜덤 소재 뽑기")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(setButtonLabelColor(isPressed))
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity)
                .background(
                    setButtonBackground(isPressed)
                )
        }
    }
}

private extension RandomStoryView {
    
    @ViewBuilder
    func ContentBox() -> some View {
        Text("다크 페이트: 죽음의 예언")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.vertical, 38)
            .foregroundColor(Color.OasisColors.darkGreen)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.OasisColors.yellow70)
            )
        
    }
}

private extension RandomStoryView {
    
    @ViewBuilder
    func BottomButtons() -> some View {
        HStack(spacing: 24) {
            Button {
                
            } label: {
                Text("다시 뽑기")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical, 13)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.OasisColors.white80)
                    )
            }
            
            Button {
                
            } label: {
                Text("시작하기")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical, 13)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.OasisColors.yellow)
                    )
            }
        }
        .foregroundColor(Color.OasisColors.darkGreen)
        .opacity(setButtonsOpacity(isContentDelivered))
    }
}

struct RandomStoryView_Previews: PreviewProvider {
    static var previews: some View {
        RandomStoryView()
    }
}
