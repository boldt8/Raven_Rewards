//
//  Raven Shop.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 11/29/24.
//

import SwiftUI

struct Raven_Shop: View {
    var data: RavenShopData
    init(data: RavenShopData) {
        self.data = data
    }
    
    var body: some View {
        NavigationView {
            List(data.listData) {item in
                NavigationLink(destination: ListDetailView(item: item)) {
                    ListElementView(item: item)
                }
            }.navigationBarTitle("RavenShop")
        }
    }
}




