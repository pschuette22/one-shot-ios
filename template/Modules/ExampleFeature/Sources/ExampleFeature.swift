import SwiftUI

public enum ExampleFeature {
    public static func greeting() -> String {
        "Hello from ExampleFeature!"
    }
}

public struct ExampleFeatureView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 8) {
            Text("ExampleFeature")
                .font(.headline)
            Text(ExampleFeature.greeting())
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ExampleFeatureView()
}
