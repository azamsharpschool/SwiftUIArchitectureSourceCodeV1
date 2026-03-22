//
//  ContentView.swift
//  MyGreenPlace
//
//  Created by Mohammad Azam on 1/23/26.
//

import SwiftUI

struct ListRow<LeadingAccessoryView: View, TrailingAccessoryView: View>: View {
    
    let title: String
    var subtitle: String?
    var imageURL: URL?
    var leadingAccessoryView: LeadingAccessoryView
    var trailingAccessoryView: TrailingAccessoryView
    var onEvent: ((ListRowEvent) -> Void)? = nil
    
    enum ListRowEvent {
        case onSelect
        case onLongPress
    }
    
    init(title: String, subTitle: String? = nil, imageURL: URL? = nil, @ViewBuilder leadingAccessoryView: () -> LeadingAccessoryView = { EmptyView() }, @ViewBuilder trailingAccessoryView: () -> TrailingAccessoryView = { EmptyView() }, onEvent: ((ListRowEvent) -> Void)? = nil) {
        self.title = title
        self.subtitle = subTitle
        self.imageURL = imageURL
        self.leadingAccessoryView = leadingAccessoryView()
        self.trailingAccessoryView = trailingAccessoryView()
        self.onEvent = onEvent
    }
    
    var body: some View {
        HStack {
            
            self.leadingAccessoryView
            
            if let imageURL {
                AsyncImage(url: imageURL) { img in
                    img.resizable()
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                } placeholder: {
                    ProgressView("Loading...")
                }
            }

            VStack(alignment: .leading) {
                Text(title)
                if let subtitle {
                    Text(subtitle)
                }
            }
            
            Spacer()
            
            self.trailingAccessoryView
            
        }
        .contentShape(Rectangle())
        .padding()
        .onTapGesture {
            onEvent?(.onSelect)
        }
        .onLongPressGesture {
            onEvent?(.onLongPress)
        }
       
    }
}

#Preview("ListRow") {
    VStack {
        
        ListRow(title: "Carrot", imageURL: nil, leadingAccessoryView: {
            CircularProgressView(progress: Double.random(in: 0...1), daysRemaining: Int.random(in: 0...90))
        }, trailingAccessoryView: {
            Text("TrailingView")
        }, onEvent: { event in
            switch event {
                case .onSelect:
                    print("onSelect")
                case .onLongPress:
                    print("onLongPress")
            }
                
        })
        
        ListRow(title: "Carrot", subTitle: "A versatile root vegetable commonly orange, but also available in purple, red, yellow, and white varieties.", imageURL: URL(string: "https://azamsharp.com/images/carrot.png")!)
        
        
    }
}

// MARK: - ListRow Preview Variations

#Preview("ListRow • Variations") {
    NavigationStack {
        List {
            // Basic
            ListRow(title: "Carrot")

            ListRow(
                title: "Carrot",
                subTitle: "Short subtitle"
            )

            // With image
            ListRow(
                title: "Carrot",
                imageURL: URL(string: "https://azamsharp.com/images/carrot.png")!
            )

            ListRow(
                title: "Carrot",
                subTitle: "A versatile root vegetable commonly orange, but also available in purple, red, yellow, and white varieties.",
                imageURL: URL(string: "https://azamsharp.com/images/carrot.png")!
            )

            // With accessories
            ListRow(
                title: "Carrot",
                subTitle: "Accessory on both sides",
                imageURL: URL(string: "https://azamsharp.com/images/carrot.png")!,
                leadingAccessoryView: {
                    Image(systemName: "leaf.fill")
                        .foregroundStyle(.green)
                },
                trailingAccessoryView: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            )

            ListRow(
                title: "Tomato",
                subTitle: "Progress accessory",
                leadingAccessoryView: {
                    CircularProgressView(progress: 0.42, daysRemaining: 18)
                },
                trailingAccessoryView: {
                    Text("Edit")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.green.opacity(0.15))
                        .clipShape(Capsule())
                }
            )

            // Edge cases
            ListRow(
                title: "Ridiculously Long Vegetable Name That Should Wrap Nicely In The Row",
                subTitle: "Another very long subtitle that tests wrapping, spacing, and makes sure the row still feels balanced even when the content is verbose.",
                imageURL: URL(string: "https://azamsharp.com/images/carrot.png")!,
                trailingAccessoryView: {
                    CircularProgressView(progress: 0.9, daysRemaining: 4)
                }
            )

            ListRow(
                title: "Onion",
                subTitle: "No image, trailing only",
                trailingAccessoryView: {
                    Toggle("", isOn: .constant(true))
                        .labelsHidden()
                }
            )
        }
        .navigationTitle("ListRow")
    }
}


#Preview("ListRow • Dynamic Type (XXXL)") {
    List {
        ListRow(
            title: "Carrot",
            subTitle: "This is a subtitle to test Dynamic Type scaling.",
            imageURL: URL(string: "https://azamsharp.com/images/carrot.png")!,
            trailingAccessoryView: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        )
    }
    .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}

#Preview("ListRow • Dark Mode") {
    List {
        ListRow(
            title: "Carrot",
            subTitle: "Dark mode preview",
            imageURL: URL(string: "https://azamsharp.com/images/carrot.png")!,
            leadingAccessoryView: {
                Image(systemName: "leaf.fill")
            },
            trailingAccessoryView: {
                CircularProgressView(progress: 0.65, daysRemaining: 12)
            }
        )
    }
    .preferredColorScheme(.dark)
}


struct VegetableListScreen: View {
    
    @Environment(GreenPlaceStore.self) private var greenPlaceStore
    
    var body: some View {
        List(greenPlaceStore.vegetables) { vegetable in
            VegetableProgressRow(vegetable: vegetable)
        }.task {
            do {
                try await greenPlaceStore.loadVegetables()
            } catch {
                print(error.localizedDescription)
            }
        }.navigationTitle("Vegetables")
    }
}

struct VegetableProgressRow: View {
    
    let vegetable: Vegetable
    
    var body: some View {
        HStack {
            
            AsyncImage(url: vegetable.thumbnailImage) { img in
                img.resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            } placeholder: {
                ProgressView("Loading...")
            }
            Text(vegetable.name)
            Spacer()
            CircularProgressView(progress: Double.random(in: 0...1), daysRemaining: Int.random(in: 0...90))
        }
    }
}

struct VegetableRow: View {
    
    let vegetable: Vegetable
    
    var body: some View {
        
            HStack {
                AsyncImage(url: vegetable.thumbnailImage) { img in
                    img.resizable()
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                } placeholder: {
                    ProgressView("Loading...")
                }
                Text(vegetable.name)
            }
        
    }
}

struct CircularProgressView: View {
    let progress: CGFloat
    let daysRemaining: Int
    @State private var animatedProgress: CGFloat = 0
    private let ringWidth: CGFloat = 8

    var body: some View {
        ZStack {
            Circle().stroke(Color.green.opacity(0.2),
                            style: .init(lineWidth: ringWidth, lineCap: .round))

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(Color.green, style: .init(lineWidth: ringWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 2), value: animatedProgress)

            VStack(spacing: 2) {
                
                Text("\(daysRemaining) days")
                    .font(.caption)
                
                /*
                DaysRemainingTextView(daysRemaining: daysRemaining)
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.green)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1) */

                Text("to Harvest")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }
            .padding(ringWidth + 4)   // keep text inside the ring
        }
        .frame(width: 75, height: 75)
        .dynamicTypeSize(.xSmall ... .xxLarge) // cap huge accessibility sizes
        .onAppear { animatedProgress = progress }
    }
}

#Preview("CircularProgressView") {
    CircularProgressView(progress: 0.75, daysRemaining: 23)
}

#Preview {
    NavigationStack {
        VegetableListScreen()
    }.environment(GreenPlaceStore())
}
