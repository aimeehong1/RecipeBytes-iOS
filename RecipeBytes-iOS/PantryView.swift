//
//  PantryView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PantryView: View {
    @FirestoreQuery(collectionPath: "users/\(Auth.auth().currentUser!.uid)/pantry") var pantry: [Item] // force unwrap because they shouldn't be on this page without authorization
    @State private var categorizedItems: [FoodType: [Item]] = [:]
    @State private var sheetIsPresented = false
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Recipe Bytes")
                }
                .bold()
                Image(systemName: "fork.knife.circle")
            }
            .font(Font.custom("PatrickHandSC-Regular", size: 30))
            .padding()
            .frame(maxWidth: .infinity)
            .background(.logo)
            .foregroundStyle(.white)
            
            NavigationStack {
                VStack {
                    HStack {
                        Button("") {}
                        
                        Spacer()
                        
                        Text("Pantry Tracker")
                            .font(Font.custom("PatrickHandSC-Regular", size: 30))
                        Spacer()
                        
                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .tint(.logo)
                        }
                    }
                    .padding()
                    
                    pantryList
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .tint(.white)
                    }
                }
            }
            .onAppear() {
                fetchAllCategories()
            }
            .onChange(of: pantry) {
                fetchAllCategories()
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    ItemDetailView(item: Item(), collection: "pantry")
                }
            }
        }
    }
    
    func fetchCategoryData(for category: FoodType, completion: @escaping ([Item]) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("pantry").whereField("type", isEqualTo: category.rawValue).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching \(category.rawValue): \(error.localizedDescription)")
                completion([])
            } else {
                let items = snapshot?.documents.compactMap { doc -> Item? in
                    try? doc.data(as: Item.self)
                } ?? []
                completion(items)
            }
        }
    }
    
    func fetchAllCategories() {
        for category in FoodType.allCases {
            fetchCategoryData(for: category ) { items in
                categorizedItems[category] = items
            }
        }
    }
    
    func checkExpirationStatus(for expirationDate: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date.now
        
        // Extract just the year, month, and day components for comparison
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let expirationDateComponents = calendar.dateComponents([.year, .month, .day], from: expirationDate)
        
        // Check if the item is expiring today
        if currentDateComponents == expirationDateComponents {
            return "EXPIRES TODAY"
        }
        
        // Calculate the difference in days
        let daysUntilExpiration = calendar.dateComponents([.day], from: currentDate, to: expirationDate).day ?? 0
        if daysUntilExpiration < 0 {
            return "EXPIRED"
        } else {
            return "Expires in \(daysUntilExpiration + 1) \(daysUntilExpiration + 1 == 1 ? "day" : "days")"
        }
    }
}

#Preview {
    PantryView()
}

extension PantryView {
    var pantryList: some View {
        List {
            ForEach(FoodType.allCases, id: \.self) { category in
                Section {
                    if let items = categorizedItems[category] {
                        ForEach(items) { item in
                            NavigationLink {
                                ItemDetailView(item: item, collection: "pantry")
                            } label: {
                                HStack {
                                    Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                        .onTapGesture {
                                            ItemViewModel.toggleCheck(item: item, collection: "pantry")
                                        }
                                    Text(item.name)
                                    
                                    Spacer()
                                    
                                    let expirationMessage = checkExpirationStatus(for: item.expirationDate)
                                    Text(expirationMessage)
                                        .background(expirationMessage.contains("EXPIRE") ? .red : .logo)
                                }
                            }
                            .font(Font.custom("PatrickHandSC-Regular", size: 20))
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    ItemViewModel.deleteItem(item: item, collection: "pantry")
                                }
                            }
                        }
                    }
                } header: {
                    Text(category.rawValue.capitalized)
                }
            }
        }
        .listStyle(.plain)
        .headerProminence(.increased)
    }
}
