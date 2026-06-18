import SwiftUI
import Widgets

struct JobLocationSectionView: View {
    @Binding var address: String
    @Binding var latitude: Double?
    @Binding var longitude: Double?

    @State private var isPresented = false

    var body: some View {
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
