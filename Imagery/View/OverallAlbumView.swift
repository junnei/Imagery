//
//  OverallAlbumView.swift
//  Imagery
//
//  Created by Nayeon Kim on 2023/09/03.
//

import SwiftUI

struct OverallAlbumView: View {
    let title = "일러스트 모음"
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
                
                //TODO: Subheader, AlbumGrid 데이터 연동
                Subheader()
                    .padding(.top, 12)
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

extension OverallAlbumView {
    //TODO: 앨범 저장 func 추가
}

private extension OverallAlbumView {
    
    @ViewBuilder
    func HeaderView() -> some View {
        ZStack {
            Button {
                GameManager.shared.gameState = .initial
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

private extension OverallAlbumView {
    
    @ViewBuilder
    func Subheader() -> some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 20) {
                ForEach(0..<DataManager.shared.subjectList.count) { idx in
                    VStack(spacing: 2) {
                        Text(DataManager.shared.subjectList[idx])
                            .fontWeight(.semibold)
                            .foregroundColor(setSubheaderItemColor(idx))
                            .onTapGesture {
                                tagIdx = idx
                            }
                        setSubheaderItemStorke(idx)
                    }
                }
                .padding(.leading, 20)
            }
        }
    }
}

private extension OverallAlbumView {
    
    @ViewBuilder
    func IllustView(_ img: String) -> some View {
        ZStack {
            Color.OasisColors.darkGreen.opacity(0.9)
            
            VStack(spacing: 44) {
                Spacer()
                
                ZStack {
                    /*
                    Text("일러스트 제목")
                        .frame(maxWidth: .infinity, alignment: .center)
                    */
                    Button {
                        self.showIllustPopup = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .fontWeight(.semibold)
                .foregroundColor(Color.OasisColors.white)
                .padding(.bottom, 3)
                .padding(.horizontal, 16)
                
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
                
                AsyncImage(url: URL(string: img)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                        .opacity(0.5)
                        .overlay {
                            ProgressView()
                        }
                }
                .frame(width: 390, height: 390)
                
                Spacer()
                
                SaveButton(img)
                    .padding(.horizontal, margin)
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

private extension OverallAlbumView {
    
    @ViewBuilder
    func SaveButton(_ img:String) -> some View {
        Button {
            
        } label: {
            Text("일러스트 내 앨범에 저장하기")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.OasisColors.white)
                .padding(.vertical, 23)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.OasisColors.white)
                        .background(Color.OasisColors.white10)
                )
        }
    }
}

struct OverallAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        OverallAlbumView()
    }
}
