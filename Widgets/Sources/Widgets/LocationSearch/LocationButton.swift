import SwiftUI

public struct LocationButton: View {
    @Binding var address: String
    @Binding var latitude: Double?
    @Binding var longitude: Double?

    @State private var isPresented = false
    
    public init(
        address: Binding<String>,
        latitude: Binding<Double?>,
        longitude: Binding<Double?>,
    ) {
        _address = address
        _latitude = latitude
        _longitude = longitude
    }

    public var body: some View {
        Button {
            isPresented = true
        } label: {
            HStack {
                Label {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(address.isEmpty ? "Add Location" : "Location")

                        if !address.isEmpty {
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
            LocationSearchPage(
                address: $address,
                latitude: $latitude,
                longitude: $longitude,
                requiresCoordinate: true
            )
        }
    }
}

#Preview {
    @Previewable @State var address: String = ""
    @Previewable @State var latitude: Double?
    @Previewable @State var longitude: Double?
    List {
        LocationButton(
            address: $address,
            latitude: $latitude,
            longitude: $longitude
        )
    }
}
