//
//  ContentView.swift
//  Food Ordering App
//
//  Created by KhaleD HuSsien on 19/12/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Food Ordering App")
            .frame(width: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.green.cornerRadius(15))
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
