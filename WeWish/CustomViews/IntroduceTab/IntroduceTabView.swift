//
//  IntroduceTabView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 19.12.23.
//

import SwiftUI

struct IntroduceTabView: View {
    
    // MARK: - Properties
    private var introduceTabModel: IntroduceTabModel
    
    init(_ introduceTabModel: IntroduceTabModel) {
        self.introduceTabModel = introduceTabModel
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: introduceTabModel.mainImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                Text(introduceTabModel.mainText)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                
                VStack(alignment: .leading) {
                    if introduceTabModel.id == 0 {
                        ForEach(IntroduceTabRowData.owned) { data in
                            HStack {
                                VStack {
                                    Image(systemName: data.imageName)
                                        .font(.title.weight(.semibold))
                                        .foregroundStyle(CustomColor.green)
                                        .padding(.horizontal)
                                }
                                .frame(width: 70)
                                VStack(alignment: .leading) {
                                    Text(data.text)
                                        .fontWeight(.medium)
                                    Text(data.description)
                                        .font(.footnote)
                                        .fontWeight(.light)
                                        .foregroundStyle(.gray)
                                }
                                .padding(.trailing)
                            }
                            .padding(.top, 15)
                        }
                    } else if introduceTabModel.id == 1 {
                        ForEach(IntroduceTabRowData.shared) { data in
                            HStack {
                                VStack {
                                    Image(systemName: data.imageName)
                                        .font(.title.weight(.medium))
                                        .foregroundStyle(CustomColor.green)
                                        .padding(.horizontal)
                                }
                                .frame(width: 70)
                                VStack(alignment: .leading) {
                                    Text(data.text)
                                        .fontWeight(.medium)
                                    Text(data.description)
                                        .font(.footnote)
                                        .fontWeight(.light)
                                        .foregroundStyle(.gray)
                                }
                                .padding(.trailing)
                            }
                            .padding(.top, 15)
                        }
                    } else if introduceTabModel.id == 2 {
                        ForEach(IntroduceTabRowData.manageAccount) { data in
                            HStack {
                                VStack {
                                    Image(systemName: data.imageName)
                                        .font(.title.weight(.medium))
                                        .foregroundStyle(CustomColor.green)
                                        .padding(.horizontal)
                                }
                                .frame(width: 70)
                                VStack(alignment: .leading) {
                                    Text(data.text)
                                        .fontWeight(.medium)
                                    Text(data.description)
                                        .font(.footnote)
                                        .fontWeight(.light)
                                        .foregroundStyle(.gray)
                                }
                                .padding(.trailing)
                            }
                            .padding(.top, 15)
                        }
                    }
                }
            }
            .padding(.vertical)
            .background(CustomColor.whiteAndSystemGray5)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.6), radius: 2, x: 1, y: 1)
            .padding(.horizontal, 10)
            .padding(.top, 7)
        }
        .background(.clear)
    }
}

//#Preview {
//    IntroduceTabView()
//}
