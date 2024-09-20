import SwiftUI

struct ContentView: View {
    @State private var showSecondView = false
    @State private var showChoiceView = false
    @State private var options =
    [
        "Take out the trash",
        "Play video games",
        "Work on 3390 Project",
        "Sleep"
    ]
    @State private var decidedChoice = "" // To store the decision
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Scrollable List with a flexible height and some padding
            VStack(alignment: .leading) {
                Text("Your Options")
                    .frame(maxWidth: .infinity, alignment: .center) // Centers the text horizontally
                    .font(.headline)
                    .padding(.top, 0) // Adjust this value to control the top spacing
                Spacer()
             
        
                // Use a flexible frame for better scroll behavior
                List {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                            .padding(.vertical, 5)
                    }
                    .onDelete(perform: deleteItems)
                    
                }
                .listStyle(PlainListStyle()) // A simpler list style with less built-in padding
                .padding(.top, 10) // Adjust this if needed
                .frame(maxHeight: 600) // Ensure enough height to enable scrolling
                .cornerRadius(10)
                
            }
            
            // Add and Decide buttons stacked with padding
            VStack(spacing: 15) {
                Button(action: {
                    showSecondView = true
                }) {
                    Text("Add New Option")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showSecondView) {
                    SecondView(showSecondView: $showSecondView, options: $options)
                }
                
                Button(action: {
                    decideOption()
                }) {
                    Text("Make a Choice!")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .alert(isPresented: $showChoiceView) {
                    Alert(title: Text("Your Choice"), message: Text(decidedChoice), dismissButton: .default(Text("OK")))
                }
            }
        }
        .padding()
    }
    
    // Function to delete items from the options list
    func deleteItems(at offsets: IndexSet) {
        options.remove(atOffsets: offsets)
    }
    
    // Function to make a random choice and trigger the alert
    func decideOption() {
        guard !options.isEmpty else { return }
        decidedChoice = options.randomElement() ?? ""
        showChoiceView = true
    }
}

struct SecondView: View {
    @Binding var showSecondView: Bool
    @Binding var options: [String]
    @State private var newOption = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Option")
                .font(.title2)
                .fontWeight(.bold)
            
            TextField("Enter New Option", text: $newOption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Add and Cancel buttons with spacing
            VStack(spacing: 15) {
                Button(action: {
                    if !newOption.isEmpty {
                        options.append(newOption)
                        showSecondView = false
                    }
                }) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    showSecondView = false
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

