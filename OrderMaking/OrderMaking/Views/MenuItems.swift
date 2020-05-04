//
//  MenuItems.swift
//  OrderMaking
//
//  Created by Kittu Lalli on 29/04/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import SwiftUI

struct MenuItems: View {
    
    @State var menuItems: [Menu] = Menu.allItems()
    
    var body: some View {
        return NavigationView {
            List {
                ForEach(0..<menuItems.count, id:\.self) { index in
                    Section(header:
                        HStack(){
                            Text(self.menuItems[index].category.rawValue)
                                .frame(height: 40)
                                .foregroundColor(Color.red)
                                .foregroundColor(Color(UIColor.gray_R238_G238_B238))
                        }.onTapGesture {
                            self.menuItems[index].isExpanded.toggle()
                    }) {
                        if self.menuItems[index].isExpanded {
                            ForEach(self.menuItems[index].items, id: \.id) { menu in
                                ItemCell(item: menu)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Yummy Menu..!")
            .navigationBarItems(trailing: PlaceOrderButtonView())
        }
    }
}

struct PlaceOrderButtonView: View {
    
    @State var showSuccess: Bool = false
    
    var body: some View {
            Button("Place Order") {
                self.showSuccess.toggle()
            }.padding(8)
                .background(Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(5.0)
                .alert(isPresented: self.$showSuccess, content: {
                    Alert(title: Text("Hurrah...!"), message: Text("Your order placed.\nWait till lock down complete to receive the order"))
                })
    }
}

struct ItemCell: View {
    
    @State var item: Item
    
    var body: some View {
        return HStack() {
            VegIndicator(isVeg: true)
                .frame(width: 15, height: 15)
            VStack(alignment: .leading) {
                Text(item.name).font(.body)
                Text((Locale.current.currencySymbol ?? "") + item.cost)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            StepperView(count: self.$item.count).padding().buttonStyle(DefaultButtonStyle())
                .frame(height: 44)
        }
    }
}

struct VegIndicator: View {
    
    let isVeg: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().fill(Color.clear)
                .border((isVeg ? Color.green : Color.red), width: 1.0)
            Circle().fill((isVeg ? Color.green : Color.red)).padding([.leading, .trailing, .top, .bottom], 3.0)
        }
    }
}

struct StepperView:View {
    
    @Binding var count: Int
    
    var body: some View {
        HStack(spacing: 0) {
            StepperButton(content: Text("-").font(.title).foregroundColor(Color(UIColor.black_R8_G8_B8))) {
                self.count = Swift.max(self.count - 1, 0)
            }.cornerRadius(15.0, corners: [.topLeft, .bottomLeft])
                .buttonStyle(PlainButtonStyle())
            Text("\(self.count)")
                .font(.subheadline)
                .foregroundColor(Color.red)
                .frame(width: 20)
                .frame(maxHeight: .infinity)
                .background(Color(UIColor.gray_R238_G238_B238))
            StepperButton(content: Text("+").font(.title).foregroundColor(Color(UIColor.black_R8_G8_B8))) {
                self.count += 1
            }.cornerRadius(15.0, corners: [.topRight, .bottomRight])
                .buttonStyle(PlainButtonStyle())
        }.frame(maxHeight: 35)
    }
}

struct StepperButton: View {
    
    let content: Text
    let handler: (() -> Void)
    
    var body: some View {
        Button(action: {
            self.handler()
        }, label: {
            content
        }) .frame(width: 30, alignment: .center)
            .frame(maxHeight: 35)
            .background(Color(UIColor.gray_R238_G238_B238))
    }
}

extension UIColor {
    
    static var gray_R238_G238_B238: UIColor = #colorLiteral(red: 0.9333333333, green: 0.9333856702, blue: 0.9333333333, alpha: 1)
    static var black_R8_G8_B8: UIColor = #colorLiteral(red: 0.03136632219, green: 0.03137653694, blue: 0.03136408702, alpha: 1)
    static var gray_R225_G225_B225: UIColor = #colorLiteral(red: 0.8823529412, green: 0.8824027181, blue: 0.8823529412, alpha: 1)
}

extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
