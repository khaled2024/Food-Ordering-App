//
//  ItemView.swift
//  Food Ordering App
//
//  Created by KhaleD HuSsien on 19/12/2022.
//

import SwiftUI
import SDWebImageSwiftUI
struct ItemView: View {
    var item: Item
    var body: some View {
        VStack{
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 30,height: 250)
            HStack(spacing: 8){
                Text(item.item_name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer(minLength: 0)
                //Ratings View
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.item_ratings) ?? 0 ? .pink : .gray)
                }
            }
            .padding([.trailing,.leading], 10)
            HStack{
                Text(item.item_details)
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: .darkGray))
                    .lineLimit(3)
                Spacer(minLength: 0)
            }
            .padding([.trailing,.leading,.bottom], 10)
            .padding(.vertical, 5)
        }
        .background(.black.opacity(0.1))
        .cornerRadius(20)
    }
}
