//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Kamol Madaminov on 02/04/25.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $order.name)
                TextField("Street adress", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip code", text: $order.zipCode)
            }
            
            Section{
                NavigationLink("Checkout"){
                    CheckoutView(order: order)
                }
                .simultaneousGesture(TapGesture().onEnded{
                    saveDate()
                })
            }
            .disabled(!order.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            loadData()
        }
    }
    
    func saveDate() {
        guard let encodedData = try? JSONEncoder().encode(order) else { return }
        UserDefaults.standard.set(encodedData, forKey: "order")
    }
    
    func loadData() {
            if let data = UserDefaults.standard.data(forKey: "order") {
                if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                    order.name = decodedOrder.name
                    order.streetAddress = decodedOrder.streetAddress
                    order.city = decodedOrder.city
                    order.zipCode = decodedOrder.zipCode
                }
            }
        }
}

#Preview {
    AddressView(order: Order())
}
