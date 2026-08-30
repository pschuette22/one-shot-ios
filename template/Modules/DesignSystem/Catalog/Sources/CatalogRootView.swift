import DesignSystem
import SwiftUI

/// The catalog's table of contents.
struct CatalogRootView: View {
    private enum Page: String, CaseIterable, Identifiable {
        case color = "Color"
        case typography = "Typography"
        case layout = "Spacing & Radius"
        case components = "Components"

        var id: String { rawValue }

        var subtitle: String {
            switch self {
            case .color: "Surface, text, brand"
            case .typography: "The TextStyle scale"
            case .layout: "The spacing and corner radius scales"
            case .components: "Cards and other seed components"
            }
        }

        var systemImage: String {
            switch self {
            case .color: "paintpalette"
            case .typography: "textformat"
            case .layout: "square.resize"
            case .components: "square.on.square"
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(Page.allCases) { page in
                NavigationLink(value: page) {
                    Label {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxs) {
                            Text(page.rawValue).textStyle(.body)
                            Text(page.subtitle).textStyle(.caption)
                        }
                    } icon: {
                        Image(systemName: page.systemImage)
                            .foregroundStyle(Color.Brand.primary)
                    }
                }
            }
            .navigationTitle("Design System")
            .navigationDestination(for: Page.self) { page in
                destination(for: page)
                    .navigationTitle(page.rawValue)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    @ViewBuilder
    private func destination(for page: Page) -> some View {
        switch page {
        case .color: ColorCatalogPage()
        case .typography: TypographyCatalogPage()
        case .layout: LayoutCatalogPage()
        case .components: ComponentsCatalogPage()
        }
    }
}

#Preview {
    CatalogRootView()
}
