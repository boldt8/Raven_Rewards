//
//  RavenShopData.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 11/29/24.
//

import Foundation

struct RavenShopData {

    var listData: [Post] = [
        Post(id: "test", caption: "test", postedDate: "test", postUrlString: "test", likers: ["test"])
    ]
    
    init(posts: [Post]){
       listData = posts
    }
    
    
}
