//
//  HistoryView.swift
//  Imagery
//
//  Created by Jun on 2023/09/03.
//

import SwiftUI

struct HistoryView: View {
    let title = "나의 이야기 기록"
    let margin = 20.0
    
    @State var tagIdx = 0
    @State var showIllustPopup = false
    @State var imgName: String?
    
    var body: some View {
        ZStack {
            Color.OasisColors.darkGreen
                .ignoresSafeArea()
            
            VStack {
                HeaderView()
                    .padding(.top, 54)
                
                HistoryGrid()
                    .padding(.top, 12)
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
    func setSubheaderItemColor(_ idx: Int) -> Color {
        if idx == tagIdx {
            return Color.OasisColors.yellow
        } else {
            return Color.OasisColors.white
        }
    }
    
    func setSubheaderItemStorke(_ idx: Int) -> some View {
        if idx == tagIdx {
            let stroke = Rectangle()
                .frame(height: 3)
                .foregroundColor(Color.OasisColors.yellow)
            return AnyView(stroke)
        } else {
            return AnyView(EmptyView())
        }
    }
}

private extension HistoryView {
    
    @ViewBuilder
    func HeaderView() -> some View {
        ZStack {
            Button {
                GameManager.shared.gameState = .initial
            } label: {
                Image(systemName: HeaderItem.back.label)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(width: 36, height: 36)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(title)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .fontWeight(.semibold)
        .foregroundColor(Color.OasisColors.white)
        .padding(.horizontal, 16)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
