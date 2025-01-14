//
//  ItemDetailView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import SwiftUI

struct ItemDetailView: View {
    @State var item: Item
    @State var collection: String
    @State var name = ""
    @State var quantity = 0
    @State var type: FoodType = .produce
    @State var expirationDate = Date.now
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Add Item")
                    .font(Font.custom("PatrickHandSC-Regular", size: 50))
                    .frame(maxWidth: .infinity)
                    .bold()

                Group {
                    Text("Name: ")
                        .bold()
                    
                    TextField("Enter item name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 1)
                        }
                }
                .font(Font.custom("PatrickHandSC-Regular", size: 23))
                .padding(.bottom)
                
                    
                HStack {
                    Text("Quantity:")
                    Stepper("\(quantity)", value: $quantity, in: 0...100)
                        .foregroundStyle(.darkerLogo)
                }
                .font(Font.custom("PatrickHandSC-Regular", size: 23))
                .padding(.bottom)
                
                HStack {
                    Text("Item Category: ")
                        .bold()
                        .font(Font.custom("PatrickHandSC-Regular", size: 23))
                    
                    Spacer()
                    
                    Picker("", selection: $type) {
                        ForEach(FoodType.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                        }
                    }
                    .tint(.darkerLogo)
                }
                .padding(.bottom)
                
                DatePicker("Expiration Date:", selection: $expirationDate, displayedComponents: [.date])
                    .font(Font.custom("PatrickHandSC-Regular", size: 23))
                    .tint(.darkerLogo)

                Spacer()
            }
            .padding()
        }
        .toolbar() {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        item.name = name
                        item.quantity = quantity
                        item.type = type
                        item.expirationDate = expirationDate
                        let _ = print(await ItemViewModel.saveItem(item: item, collection: collection) ?? "No item.id")
                    }
                    dismiss()
                }
            }
        }
        .tint(.darkerLogo)
        .navigationBarBackButtonHidden()
        .onAppear() {
            name = item.name
            quantity = item.quantity
            type = item.type
            expirationDate = item.expirationDate
        }
    }
}

#Preview {
    NavigationStack {
        ItemDetailView(item: Item(id: "1", name: "🥔 Potatoes", quantity: 5, type: .produce, expirationDate: Date()), collection: "grocery")
    }
}
