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
                ForEach(0..<10) { _ in
                    VStack(spacing: 8) {
                        Image(imgName)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                self.showIllustPopup = true
                                self.selectedImg = imgName
                            }
                        Text(imgName)
                            .font(.subheadline)
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
