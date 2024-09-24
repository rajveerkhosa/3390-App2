import SwiftUI
import Foundation   //  Framework for Generating Random Numbers

//  Defines Struct to represent options
//  Conforms to Identifiable Protocol ?
struct Option: Identifiable {
    let id = UUID()     // Makes a Unique ID for every option
    let name: String
    let weight: Int
}

//  Main View
struct ContentView: View {
    @State private var showSecondView = false
    @State private var showChoiceView = false
    
    //  Initialize some Sample Options
    @State private var options: [Option] =
    [
        Option(name: "Take out the trash", weight: 1),
        Option(name: "Play video games", weight: 5),
        Option(name: "Work on 3390 Project", weight: 10),
        Option(name: "Sleep", weight: 2)
    ]
    
    @State private var decidedChoice = "" // To store the decision
    
    //  View that Defines Visual Structure/Layout
    var body: some View {
        VStack(spacing: 20) {
            
            // Scrollable List with a flexible height and some padding
            VStack(alignment: .leading) {
                Text("Your Options")
                    .frame(maxWidth: .infinity, alignment: .center) // Centers the text horizontally
                    .font(.headline)
                    .padding(.top, 0)
                Spacer()    //  Adds space to push elements down
                
                List {
                    ForEach(options)
                    { option in
                        HStack  // <-- Makes it so each option is shown in a horizontal stack
                        {
                            Text(option.name)
                            Spacer()
                            Text("\(option.weight)")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete(perform: deleteItems)
                    
                }
                .listStyle(PlainListStyle()) // Simple list style
                .padding(.top, 10)
                .frame(maxHeight: 600)
                .cornerRadius(10)
                
            }
            
            // Visual Stack for Add and Decide buttons
            VStack(spacing: 15) {
                Button(action: {
                    showSecondView = true
                }) {
                    Text("Add New Option")
                        .frame(maxWidth: .infinity) // Makes button expand to max width of container
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                //  Pass showSecondView binding and options array to SecondView
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
                //  Alert Modifier to show popup with decided choice
                .alert(isPresented: $showChoiceView) {
                    Alert(title: Text("Your Choice"),
                          message: Text(decidedChoice),
                          dismissButton: .default(Text("OK")))
                }
            }
        }
        .padding()
    }
    
    // Function to delete items from the options list
    func deleteItems(at offsets: IndexSet) {
        options.remove(atOffsets: offsets)
    }
    
    // Function to make a random choice
    func decideOption() {
        guard !options.isEmpty else { return }  //  Makes sure list isn't empty
        
        //  Calculates total weight
        let totalWeight = options.reduce(0) { $0 + $1.weight }
        //  $0 is an accumulator, so it starts at 0 and then accumulates the sum
        //  $1 represents each Option object in the list
        //  $1.weight refers to weight of each option.
        
        //  Generates random number between 0 and totalWeight
        let randomNumber = Int.random(in: 0..<totalWeight)
        
        //  Tracks cumulativeWeight
        var cumulativeWeight = 0
        
        //  Iterate through each option
        for option in options
        {
            cumulativeWeight += option.weight   //  Adds option's weight to cumulative total
            if randomNumber < cumulativeWeight  //  If randomNumber is less than cumulative
            {
                decidedChoice = option.name     //  Set the selected option
                break                           //  Stop the loop once option is selected
            }
            
        }
        
        //  Show alert with selected option
        showChoiceView = true
    }
}

//  View for adding new option
struct SecondView: View {
    //  Bindings pass values from parent
    @Binding var showSecondView: Bool
    @Binding var options: [Option]
    
    //  State variables are for input fields
    @State private var newOptionName = ""
    @State private var newOptionWeight = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Option")
                .font(.title2)
                .fontWeight(.bold)
            
            //  Text field for entering a new option
            TextField("Enter New Option", text: $newOptionName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            //  Text field for entering new option weight
            TextField("Enter Weight", text: $newOptionWeight)
                .keyboardType(.numberPad) // Ensures only numbers can be entered
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Vertical Stack for Add and Cancel buttons
            VStack(spacing: 15) {
                Button(action: {
                    //  If the inputs are good
                    if let weight = Int(newOptionWeight), !newOptionName.isEmpty
                    {
                        options.append(Option(name: newOptionName, weight: weight)) //  Adds new option to list
                        showSecondView = false  //  Closes the view
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
                
                //  Button to cancel adding new option
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
