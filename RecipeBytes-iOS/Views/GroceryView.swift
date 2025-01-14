//
//  GroceryView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct GroceryView: View {
    @FirestoreQuery(collectionPath: "users/\(Auth.auth().currentUser?.uid ?? "")/grocery") var grocery: [Item]
    @State private var categorizedItems: [FoodType: [Item]] = [:]
    @State private var isChecked: [Item] = []
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
                        Button {
                            ItemViewModel.getCheckedItems(collection: "grocery") { result in
                                switch result {
                                case .success(let items):
                                    for item in items {
                                        isChecked.append(item)
                                    }
                                case .failure(let error):
                                    print("😡 ERROR: failed to retrieve items. \(error.localizedDescription)")
                                }
                            }
                            Task {
                                ItemViewModel.refreshUserProfile()
                                if await ItemViewModel.moveItem(items: isChecked, from: "grocery", to: "pantry") == true {
                                    let _ = print("Moved \(isChecked) from grocery to pantry")
                                }
                            }
                        } label: {
                            VStack {
                                Text("Move to")
                                Text("Pantry")
                                Image(systemName: "arrowshape.right.fill")
                            }
                            .font(Font.custom("PatrickHandSC-Regular", size: 15))
                        }
                        
                        Spacer()
                        
                        Text("Grocery List")
                            .font(Font.custom("PatrickHandSC-Regular", size: 30))
                        
                        Spacer()

                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            VStack {
                                Text("Add Item")
                                    .font(Font.custom("PatrickHandSC-Regular", size: 15))
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .tint(.logo)
                    .padding()
                 
                    groceryList
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
            .onChange(of: grocery) {
                fetchAllCategories()
            }
            .fullScreenCover(isPresented: $sheetIsPresented) {
                NavigationStack {
                    ItemDetailView(item: Item(), collection: "grocery")
                }
            }
        }
    }
    
    func fetchCategoryData(for category: FoodType, completion: @escaping ([Item]) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("grocery").whereField("type", isEqualTo: category.rawValue).getDocuments { snapshot, error in
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
}

#Preview {
    GroceryView()
}

extension GroceryView {
    var groceryList: some View {
        List {
            ForEach(FoodType.allCases, id: \.self) { category in
                Section {
                    if let items = categorizedItems[category] {
                        ForEach(items) { item in
                            NavigationLink {
                                ItemDetailView(item: item, collection: "grocery")
                            } label: {
                                HStack {
                                    Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                        .onTapGesture {
                                            ItemViewModel.toggleCheck(item: item, collection: "grocery")
                                        }
                                    Text(item.name)
                                    if item.quantity > 1 {
                                        Text("(\(item.quantity))")
                                    }
                                }
                            }
                            .font(Font.custom("PatrickHandSC-Regular", size: 20))
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    ItemViewModel.deleteItem(item: item, collection: "grocery")
                                }
                                .tint(.logo)
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
