//
//  ContentView.swift
//  Food Ordering App
//
//  Created by KhaleD HuSsien on 19/12/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            Home()
                .navigationBarHidden(true)
                . navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
