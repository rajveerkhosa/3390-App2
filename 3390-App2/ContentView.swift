//
//  ContentView.swift
//  3390-App2
//
//  Created by Rajveer Singh Khosa on 9/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showSecondView = false
    
    var body: some View {
        VStack {
            Button(action: {
                showSecondView = true
            }) {
                Text("New Option")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSecondView){
                SecondView(showSecondView: $showSecondView)
            }
        }
        .padding()
    }
}

struct SecondView: View {
    @Binding var showSecondView: Bool
    
    var body: some View {
        VStack {
            Text("Add New Option")
            Text("Weight")
            Text("Add")
            Text("Remove")
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
