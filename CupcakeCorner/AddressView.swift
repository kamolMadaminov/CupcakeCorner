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
            }
            .disabled(!order.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
