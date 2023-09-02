//
//  StartView.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        VStack {
            Text("당신의 이야기의 소재를\n랜덤으로 뽑아보아요")
                .foregroundColor(Color.Yellow.yellow.color)
                .font(.system(size: 32))
                .bold()
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Yellow.yellow.color)
                .frame(height: 128)
                .overlay {
                    Text("랜덤 소재 뽑기")
                        .font(.system(size: 30))
                        .bold()
                }
                .onTapGesture {
                    GameManager.shared.gameState = .playing
                }
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Yellow.yellow.color)
                .frame(height: 72)
                .overlay {
                    Text("다음")
                        .font(.system(size: 30))
                        .bold()
                }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
