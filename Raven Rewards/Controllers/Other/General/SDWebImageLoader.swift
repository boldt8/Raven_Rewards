//
//  SDWebImageLoader.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 11/30/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct SDWebImageLoader: View {
    init(url: String, contentMode: ContentMode) {
        self.url = url
        self.contentMode = contentMode
    }
    
    let url: String
    var contentMode: ContentMode = .fill
    
    var body: some View {
        WebImage(url: URL(string: url))
        .onSuccess(perform: { image, data, cacheType in
                
        })
        .onFailure(perform: { error in
            
        })
        
        .resizable()
        .aspectRatio(contentMode: contentMode)

    }
}
