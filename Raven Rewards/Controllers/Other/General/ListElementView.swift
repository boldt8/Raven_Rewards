//
//  ListElementView.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 11/29/24.
//

import SwiftUI

struct ListElement: Identifiable, Codable {    
    var id = UUID()
    var image: String
    var title: String
    var text: String
}


struct ListElementView: View {
    
    var item: Post
    
    var body: some View  {
        
        HStack {
            SDWebImageLoader(url: item.postUrlString, contentMode: .fit)
                .frame(width: 80, height:80)
            VStack(alignment: .leading, content: {
                Text(item.caption)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .lineLimit(2)
            })
        }
    }
}

struct ListDetailView: View {
    
    var item: Post
    
    var body: some View  {
        ScrollView{
            VStack {
                HStack{
                    SDWebImageLoader(url: item.postUrlString, contentMode: .fit)
                        .frame(width: 200, height:200)
                }.frame(minWidth: 0, maxWidth: .infinity)

                Text(item.caption)
                    .padding(.horizontal, 20)
                }
        }
    }
}
