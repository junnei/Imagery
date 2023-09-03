//
//  HistoryGrid.swift
//  Imagery
//
//  Created by Jun on 2023/09/03.
//

import SwiftUI

struct HistoryGrid: View {
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 32) {
                ForEach(0..<DataManager.shared.subjectList.count) { index in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.OasisColors.white10)
                            .frame(width: 150, height: 150)
                            .overlay {
                                ZStack {
                                    Text(DataManager.shared.subjectList[index])
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.OasisColors.white)
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.OasisColors.white)
                                }
                            }
                    }
                }
            }.padding(.top, 16)
        }
        .padding(.horizontal, 4)
    }
}
