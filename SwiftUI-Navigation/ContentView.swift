import SwiftUI

struct MainPage: View {
    @State private var goTo4 = false
    
    var body: some View {
        VStack {
            Text("This is on the main page.")
            
            ForEach(1..<3) { number in
                NavigationLink(destination: ChildPage(number: number)) {
                    Text("Go to child \(number) page")
                }
            }
            
            NavigationLink(
                destination: ChildPage(number: 4),
                isActive: $goTo4
            ) {
                Text("Go to child page")
            }
            
            Button("Toggle") {
                // Could make a REST call here.
                // Could conditionally decide whether to set goTo4 to true.
                goTo4 = true
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
    var body: some View {
        // Usually want this at top-level.
        // One exception is when using multiple tabs
        // where each has its own NavigationView.
        NavigationView {
            MainPage()
            // This goes on a view inside NavigationView,
            // not on the NavigationView,
            // because the title can change for each page.
            // displayMode has three options:
            // large (default), inline, and automatic.
            // Automatic uses large for the top view and inline for others.
                .navigationBarTitle("Main", displayMode: .large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
