//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Kamol Madaminov on 02/04/25.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3){ image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order"){
                    Task {
                        await placeOrder()
                    }
                } .padding()
            }
            
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you", isPresented: $showingConfirmation) {
            Button("OK"){}
        } message: {
            Text(confirmationMessage)
        }
        .alert("Error", isPresented: $showingError){
            Button("Error"){}
        } message: {
            Text(errorMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        if !reachabilty() {
            errorMessage = "No internet connection. Please try again later."
            showingError = true
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order #\(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on the way"
            showingConfirmation = true
            
        } catch {
            print("Checout failed: \(error.localizedDescription)")
        }
    }
    
    func reachabilty() -> Bool {
        return (try? String(contentsOf: URL(string: "https://www.google.com")!)) != nil
    }
}

#Preview {
    CheckoutView(order: Order())
}
