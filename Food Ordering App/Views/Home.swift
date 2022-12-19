//
//  Home.swift
//  Food Ordering App
//
//  Created by KhaleD HuSsien on 19/12/2022.
//

import SwiftUI

struct Home: View {
    @StateObject var HomeModel: HomeViewModel = HomeViewModel()
    var body: some View {
        ZStack{
            VStack(spacing: 10){
                HStack(spacing: 15){
                    Button {
                        withAnimation(.easeIn) {HomeModel.showMenu.toggle()}
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.pink)
                    }
                    HStack(spacing: 10) {
                        Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver to")
                            .foregroundColor(.black)
                        Text(HomeModel.userAddress)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.pink)
                    }
                    Spacer(minLength: 0)
                }
                .padding([.horizontal,.top])
                Divider()
                HStack(spacing: 15) {
                    TextField("Search", text: $HomeModel.search)
                    if HomeModel.search != ""{
                        withAnimation(.easeInOut) {
                            Button(action: {}) {
                                Image(systemName: "magnifyingglass")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                Divider()
                Spacer()
            }
            // Slide menu...
            HStack{
                Menu(homeData: HomeModel)
                    .offset(x: HomeModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                Spacer(minLength: 0)
            }
            .background(
                Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                // closing when tap outside
                    .onTapGesture {
                        withAnimation(.easeIn) {HomeModel.showMenu.toggle()}
                    }
            )
            // alert when there is no location
            if HomeModel.noLocation {
                Text("Please Enable Location Access In Setting To Further Move On!!!")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
        .onAppear {
            // calling location delegate
            HomeModel.locationManager.delegate = HomeModel
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
