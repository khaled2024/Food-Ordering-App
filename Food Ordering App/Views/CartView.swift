//
//  CartView.swift
//  Food Ordering App
//
//  Created by KhaleD HuSsien on 20/12/2022.

import SwiftUI
import SDWebImageSwiftUI
struct CartView: View {
    @ObservedObject var homeModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            // HEADER...
            HStack(spacing: 20){
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.pink)
                }
                Text("My Cart")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer()
            }
            .padding()
            //CONTENT LIST OF CART ITEMS...
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(homeModel.cartItems) { cart in
                        // CART ITEM VIEW...
                        HStack(spacing: 15) {
                            WebImage(url: URL(string: cart.item.item_image))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            VStack(alignment: .leading, spacing: 10){
                                Text(cart.item.item_name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                Text(cart.item.item_details)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                HStack(spacing: 15) {
                                    Text(homeModel.getPrice(value: Float(truncating: cart.item.item_cost)))
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    
                                    Spacer(minLength: 0)
                                    // SUB BUTTON
                                    Button(action: {
                                        if cart.quantity > 1 {
                                            homeModel.cartItems[homeModel.getIndex(item: cart.item, isCartIndex: true)].quantity -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus")
                                            .font(.system(size: 16,weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(Color.black.opacity(0.06))
                                    Button(action: {
                                        homeModel.cartItems[homeModel.getIndex(item: cart.item, isCartIndex: true)].quantity += 1
                                    }) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 16,weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding()
                        .contextMenu{
                            // FOR DELETING...
                            Button {
                                // deleting items from cart...
                                withAnimation(.default) {
                                    let index = homeModel.getIndex(item: cart.item, isCartIndex: true)
                                    let itemIndex = homeModel.getIndex(item: cart.item, isCartIndex: false)
                                    
                                    homeModel.items[itemIndex].isAdded = false
                                    homeModel.filtered[itemIndex].isAdded = false
                                    homeModel.cartItems.remove(at: index)
                                }
                            } label: {
                                Text("Remove")
                            }
                        }
                    }
                }
            }
            // BOTTOM VIEW...
            VStack{
                HStack{
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    Spacer()
                    // calculating total price...
                    Text(homeModel.calculatingTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top,.horizontal])
                Button(action: homeModel.updateOrder) {
                    Text(homeModel.ordered ? "Cancle Order" : "Check out")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(uiColor: .systemPink),Color(uiColor: .purple).opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
                }
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(homeModel: HomeViewModel())
    }
}
