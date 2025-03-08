//
//  AddView.swift
//  iExpense
//
//  Created by Sai Nikhil Varada on 3/8/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var expenses : Expenses
    
    let types = ["Business", "Personal"]
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                
                Picker("Type of Expense", selection: $type){
                    ForEach(types, id: \.self){item in
                        Text("\(item)")
                    }
                }
                .pickerStyle(.segmented)
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add a new expense")
            .toolbar{
                Button("Cancel", role: .cancel){
                    dismiss()
                }
                Button("Add"){
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    if item.type == "Personal"{
                        expenses.personalExpense.append(item)
                    }
                    else{
                        expenses.businessExpense.append(item)
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
