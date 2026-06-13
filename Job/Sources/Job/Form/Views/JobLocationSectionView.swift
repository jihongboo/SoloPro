import SwiftUI

struct JobLocationSectionView: View {
    let address: String
    let onSelectLocation: () -> Void

    var body: some View {
        Section("Location") {
            Button {
                onSelectLocation()
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
        }
    }
}
