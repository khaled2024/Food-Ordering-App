//
//  Cart.swift
//  Food Ordering App
//
//  Created by KhaleD HuSsien on 20/12/2022.
//

import SwiftUI

struct Cart: Identifiable {
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}
