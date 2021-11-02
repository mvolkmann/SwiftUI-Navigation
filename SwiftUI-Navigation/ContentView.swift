import SwiftUI

struct MainPage: View {
    var body: some View {
        VStack {
            Text("This is on the main page.")
            NavigationLink(destination: ChildPage()) {
                Text("Go to child page")
            }
        }
    }
}

struct ChildPage: View {
    var body: some View {
        VStack {
            Text("This is on the child page.")
            NavigationLink(destination: Grandchild1Page()) {
                Text("Go to grandchild one page")
            }
            NavigationLink(destination: Grandchild2Page()) {
                Text("Go to grandchild two page")
            }
        }
    }
}

struct Grandchild1Page: View {
    var body: some View {
        Text("This is on the grandchild one page.")
    }
}

struct Grandchild2Page: View {
    var body: some View {
        Text("This is on the grandchild two page.")
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
