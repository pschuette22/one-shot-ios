import ExampleFeature
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("__APP_NAME__")
                .font(.largeTitle)
                .bold()
            Text(ExampleFeature.greeting())
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
