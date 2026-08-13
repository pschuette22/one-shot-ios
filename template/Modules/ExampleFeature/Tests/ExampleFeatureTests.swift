import Testing
@testable import ExampleFeature

@Suite("ExampleFeature")
struct ExampleFeatureTests {
    @Test func greetingIsNonEmpty() {
        #expect(!ExampleFeature.greeting().isEmpty)
    }
}
