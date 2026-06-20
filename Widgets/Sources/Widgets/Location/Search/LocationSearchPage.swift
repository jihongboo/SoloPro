import SwiftUI
import MapKit

import Model

public struct LocationSearchPage: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var location: Location?

    @State private var searchModel = LocationsModel()
    @State private var errorMessage: String?
    @FocusState private var isSearchFocused: Bool
    
    public init(location: Binding<Location?>) {
        _location = location
    }

    public var body: some View {
        @Bindable var searchModel = searchModel

        NavigationStack {
            List(searchModel.completions, id: \.formattedAddress) { completion in
                Button {
                    select(completion)
                } label: {
                    LocationView(completion: completion)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
            .overlay {
                LocationUnavailableView(viewModel: searchModel)
            }
            .searchable(text: $searchModel.searchText, prompt: Text("Search or Enter Address"))
            .navigationTitle("Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .onAppear {
                isSearchFocused = true
            }
            .alert(
                "Location Search Failed",
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { isPresented in
                        if !isPresented {
                            errorMessage = nil
                        }
                    }
                )
            ) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Unable to resolve this location.")
            }
        }
    }
}

#Preview {
    @Previewable @State var location: Location?

    LocationSearchPage(location: $location)
}

private extension LocationSearchPage {
    private func select(_ completion: MKLocalSearchCompletion) {
        Task {
            do {
                let coordinate = try await searchModel.resolveCoordinate(for: completion)
                location = .init(
                    address: completion.formattedAddress,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
                dismiss()
            } catch {
                location = nil
                errorMessage = error.localizedDescription
            }
        }
    }
}
