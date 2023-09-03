//
//  AlbumGrid.swift
//  Imagery
//
//  Created by Nayeon Kim on 2023/09/03.
//

import SwiftUI

//TODO: 일러스트 데이터로 수정
struct AlbumGrid: View {
    let columns = [GridItem(), GridItem()]
    let imgName = "DALL-E"
    
    @Binding var showIllustPopup: Bool
    @Binding var selectedImg: String?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 32) {
                ForEach(0..<DataManager.shared.dataList.count) { index in
                    VStack(spacing: 8) {
                        AsyncImage(url: URL(string: DataManager.shared.dataList[index].dall)) { image in
                            image.resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .onTapGesture {
                                    self.showIllustPopup = true
                                    self.selectedImg = DataManager.shared.dataList[index].dall
                                }
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.5))
                                .overlay {
                                    ProgressView()
                                }
                        }
                        .frame(width: 150, height: 150)
                        
                        Text(String(index))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.OasisColors.white)
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

struct AlbumGrid_Previews: PreviewProvider {
    static var previews: some View {
        AlbumGrid(showIllustPopup: .constant(false), selectedImg: .constant("DALL-E"))
    }
}
