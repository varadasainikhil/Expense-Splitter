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
    @State private var isAlertShowing = false
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
            .toolbar {
                Button("Cancel", role: .cancel){
                    dismiss()
                }
                Button("Add"){
                    if name == "" || amount == 0.00{
                        isAlertShowing.toggle()
                    }
                    else{
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        if item.type == "Personal"{
                            expenses.personalExpense.append(item)
                            dismiss()
                        }
                        else{
                            expenses.businessExpense.append(item)
                            dismiss()
                        }
                    }
                }
            }
            .alert("Error", isPresented: $isAlertShowing){
                Button("Ok"){
                    dismiss()
                }
            } message: {
                if name == "" && amount == 0.00{
                    Text("Please enter the name and the amount.")
                }else if name == ""{
                    Text("Please enter Name for the Transaction.")
                }else{
                    Text("Please enter amount.")
                }
            }
        }
       
    
    }
}

#Preview {
    AddView(expenses: Expenses())
}
