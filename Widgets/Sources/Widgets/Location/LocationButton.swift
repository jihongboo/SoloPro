import SwiftUI

import Model

public struct LocationButton: View {
    @Binding var location: Location?

    @State private var isPresented = false
    
    public init(location: Binding<Location?>) {
        _location = location
    }

    public var body: some View {
        Button {
            isPresented = true
        } label: {
            HStack {
                Label {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(location?.address == nil ? "Add Location" : "Location")

                        if let address = location?.address {
                            Text(address)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                } icon: {
                    Image(systemName: "mappin.and.ellipse")
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .foregroundStyle(.primary)
        .sheet(isPresented: $isPresented) {
            LocationSearchPage(location: $location)
        }
    }
}

#Preview {
    @Previewable @State var location: Location?
    
    List {
        LocationButton(location: $location)
    }
}
