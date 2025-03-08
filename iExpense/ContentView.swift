//
//  ContentView.swift
//  iExpense
//
//  Created by Sai Nikhil Varada on 3/8/25.
//
import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var personalExpense = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(personalExpense) {
                UserDefaults.standard.set(encoded, forKey: "personalExpense")
            }
        }
    }
    
    var businessExpense = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(businessExpense) {
                UserDefaults.standard.set(encoded, forKey: "businessExpense")
            }
        }
    }
    
    init() {
        if let savedPersonalExpenses = UserDefaults.standard.data(forKey: "personalExpense") {
            if let decodedPersonalExpenses = try? JSONDecoder().decode([ExpenseItem].self, from: savedPersonalExpenses) {
                personalExpense = decodedPersonalExpenses
            } else {
                personalExpense = []
            }
        } else {
            personalExpense = []
        }
        
        if let savedBusinessExpenses = UserDefaults.standard.data(forKey: "businessExpense") {
            if let decodedBusinessExpenses = try? JSONDecoder().decode([ExpenseItem].self, from: savedBusinessExpenses) {
                businessExpense = decodedBusinessExpenses
            } else {
                businessExpense = []
            }
        } else {
            businessExpense = []
        }
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.white, .mint], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                List {
                    Section("Personal Expenses") {
                        ForEach(expenses.personalExpense) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: "USD"))
                            }
                        }
                        .onDelete(perform: removePersonalExpense)
                    }
                    
                    Section("Business Expenses") {
                        ForEach(expenses.businessExpense) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: "USD"))
                            }
                        }
                        .onDelete(perform: removeBusinessExpense)
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("iExpense")
                .toolbar {
                    Button("Add an expense", systemImage: "plus") {
                        showingAddExpense.toggle()
                    }
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: expenses)
                }
            }
        }
    }
    
    func removePersonalExpense(at offsets: IndexSet) {
        expenses.personalExpense.remove(atOffsets: offsets)
    }
    
    func removeBusinessExpense(at offsets: IndexSet) {
        expenses.businessExpense.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
