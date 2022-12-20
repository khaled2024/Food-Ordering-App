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
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    TextField("Search", text: $HomeModel.search)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                Divider()
                if HomeModel.items.isEmpty{
                    Spacer()
                    ProgressView()
                    Spacer()
                }else{
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 25) {
                            ForEach(HomeModel.filtered) { item in
                                // Item View...
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
                                    ItemView(item: item)
                                    HStack{
                                        Text("FREE DELIVERY")
                                            .foregroundColor(.white)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal)
                                            .background(Color.pink.cornerRadius(20))
                                        Spacer(minLength: 0)
                                        Button {
                                            // for adding the prder to the Cart.
                                            HomeModel.addToCart(item: item)
                                        } label: {
                                            Image(systemName: item.isAdded ? "checkmark" : "plus")
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(item.isAdded ? Color.green : Color.pink)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding([.leading,.trailing], 10)
                                    .padding(.top, 10)
                                }
                                .frame(width: UIScreen.main.bounds.width - 30)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
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
        .onChange(of: HomeModel.search) { newValue in
            // to avoid continues search requests...
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                if newValue == HomeModel.search && HomeModel.search != ""{
                    // search data...
                    HomeModel.filterData()
                }
                if HomeModel.search == "" {
                    // reset all data...
                    withAnimation(.default) {HomeModel.filtered = HomeModel.items}
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
