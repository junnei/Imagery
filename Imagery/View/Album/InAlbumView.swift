//
//  InAlbumView.swift
//  Imagery
//
//  Created by Nayeon Kim on 2023/09/03.
//

import SwiftUI

//MARK: 스토리 내 일러스트 모음
struct InAlbumView: View {
    let title = "일러스트 모음"
    let margin = 20.0
    
    @State var showIllustPopup = false
    @State var imgName: String?
    
    var body: some View {
        ZStack {
            Color.OasisColors.darkGreen
                .ignoresSafeArea()
            
            VStack {
                HeaderView()
                    .padding(.top, 54)
                    .padding(.bottom, 36)
                
                AlbumGrid(showIllustPopup: $showIllustPopup, selectedImg: $imgName)
                Spacer()
            }
            
            if showIllustPopup {
                if let img = imgName {
                    IllustView(img)
                }
            }
        }
        .ignoresSafeArea()
    }
}

private extension InAlbumView {
    
    @ViewBuilder
    func HeaderView() -> some View {
        ZStack {
            Button {
                
            } label: {
                Image(systemName: HeaderItem.back.label)
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

private extension InAlbumView {
    
    @ViewBuilder
    func IllustView(_ img: String) -> some View {
        ZStack {
            Color.OasisColors.darkGreen.opacity(0.9)
            
            VStack(spacing: 44) {
                Spacer()
                
                Button {
                    self.showIllustPopup = false
                } label: {
                    Image(systemName: HeaderItem.xmark.label)
                        .fontWeight(.bold)
                        .foregroundColor(Color.OasisColors.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                    .padding(.trailing, margin)
                    .padding(.bottom, 3)
                
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
                
                Image(img)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        Rectangle()
                    .stroke(
                        Color.OasisColors.yellow,
                        lineWidth: 8
                    )
                    )
                    .padding(8)
                
                Text("일러스트에 손을 가져다대어 그림을 느껴보세요")
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
                
                Spacer()
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}



struct InAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        InAlbumView()
    }
}
