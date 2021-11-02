import SwiftUI

class SharedData: ObservableObject {
    @Published var v1 = 0
    @Published var v2 = "x"
}

struct DataView: View {
    // Need this to gain access.
    @EnvironmentObject var data: SharedData
    
    var body: some View {
        VStack {
            Text("v1 = \(data.v1)")
            //TODO: Why does these buttons become disabled after tapping?
            //TODO: This happens in Simulator, but not in Preview!
            Button("Add 1") { data.v1 += 1 }.buttonStyle(.bordered)
            Text("v2 = \(data.v2)")
            Button("Update") { data.v2 += "x" }.buttonStyle(.bordered)
        }
    }
}

struct MainPage: View {
    // Need this to gain access.
    @EnvironmentObject var data: SharedData
    
    // selection can be other types like Int.
    @State private var selection: String? = nil
    
    @State private var pageToggle = false
    
    var body: some View {
        VStack {
            Text("This is on the main page.")
            
            ForEach(1..<3) { number in
                NavigationLink(destination: ChildPage(number: number)) {
                    Text("Go to child \(number) page")
                }
            }
            
            // Link navigation ...
            // Also consider using the isActive argument which is an
            // @State Bool that indicates if the link should be activated.
            NavigationLink(
                destination: ChildPage(number: 4),
                tag: "four",
                selection: $selection
            ) {
                Text("Go to four")
            }
            NavigationLink(
                destination: ChildPage(number: 5),
                tag: "five",
                selection: $selection
            ) {
                Text("Go to five")
            }
            
            // Programatic navigation to the link above
            Button("Mystery Page") {
                // Could make a REST call here.
                selection = pageToggle ? "five" : "four"
                
                // Could conditionally decide how to set pageToggle.
                pageToggle.toggle()
                
                // Return to current page after 2 seconds.
                // This is like setTimeout in JavaScript.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    selection = nil
                }
            }
            
            Text("data.v1 = \(data.v1)")
            
            // Can attach an environment object to any view like this.
            //NavigationLink(destination: DataView().environmentObject(data)) {
            
            // But can also attach an environment object
            // to the NavigationView (see below)
            // to make it available in all linked views.
            NavigationLink(destination: DataView()) {
                Text("Go to DataView")
            }
        }
    }
}

struct ChildPage: View {
    var number: Int
    
    var body: some View {
        VStack {
            Text("This is on the child \(number) page.")
            ForEach(1..<4) { number in
                NavigationLink(destination: GrandchildPage(number: number)) {
                    Text("Grandchild \(number)")
                }
            }
        }
    }
}

struct GrandchildPage: View {
    var number: Int
    
    var body: some View {
        Text("This is on the grandchild \(number) page.")
    }
}

struct ContentView: View {
    @ObservedObject var data = SharedData()
    
    // Going fullscreen requires hiding both
    // the status bar and the navigation bar.
    @State private var fullscreen = false
    
    var body: some View {
        // Usually want this at top-level.
        // One exception is when using multiple tabs
        // where each has its own NavigationView.
        //
        // Currently SwiftUI only supports two customizations of the navbar.
        // It can be hidden entirely or only the back button can be hidden.
        // Other customizations require use of UIKit
        NavigationView {
            VStack {
                Button("Toggle Fullscreen") { fullscreen.toggle() }
                
                MainPage()
                // This goes on a view inside NavigationView,
                // not on the NavigationView,
                // because the title can change for each page.
                // displayMode has three options:
                // large (default), inline, and automatic.
                // Automatic uses large for the top view and inline for others.
            }
            .navigationBarTitle("Main", displayMode: .large)
            .navigationBarHidden(fullscreen)
            .navigationBarItems(
                leading:
                    Button("Down") { data.v1 -= 1 }
                        .foregroundColor(.white),
                trailing:
                    HStack {
                        Button("Up") { data.v1 += 1 }
                            .foregroundColor(.white)
                        Button("Double") { data.v1 *= 2 }
                            .foregroundColor(.white)
                    }
            )
        }
        .statusBar(hidden: fullscreen)
        // Need this make an @ObservedObject available
        // to all linked views as an @EnvironmentObject.
        // All views that use it will have their body property
        // reevaluated if the value changes.
        .environmentObject(data)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
