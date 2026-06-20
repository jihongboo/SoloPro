//
//  SwiftUIView.swift
//  Contacts
//
//  Created by 纪洪波 on 6/20/26.
//

import SwiftUI

import Model

struct AvatarView: View {
    let contact: Contact
    let size: Size
    
    init(_ contact: Contact, size: Size = .small) {
        self.contact = contact
        self.size = size
    }

    var body: some View {
        Text(initials)
            .font(size.font)
            .foregroundStyle(avatarColor)
            .padding(size.padding)
            .background(avatarColor.opacity(0.16), in: Circle())
    }
}

#Preview {
    VStack {
        AvatarView(.mock)
        AvatarView(.mock, size: .large)
    }
}

extension AvatarView {
    enum Size {
        case small
        case large
        
        var font: Font {
            switch self {
            case .small:
                    .headline.weight(.semibold)
            case .large:
                    .largeTitle.weight(.semibold)
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .small:
                12
            case .large:
                24
            }
        }
    }
}

private extension AvatarView {
    var initials: String {
        let characters = contact.name
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)

        let value = String(characters).uppercased()
        return value.isEmpty ? "?" : value
    }

    var avatarColor: Color {
        avatarColors[avatarColorIndex]
    }

    var avatarColorIndex: Int {
        let value = contact.name.unicodeScalars.reduce(0) { partialResult, scalar in
            partialResult + Int(scalar.value)
        }

        return value % avatarColors.count
    }

    var avatarColors: [Color] {
        [.purple, .green, .orange, .teal, .pink, .blue]
    }
}
