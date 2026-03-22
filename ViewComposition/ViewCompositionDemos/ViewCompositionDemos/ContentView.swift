//
//  ContentView.swift
//  ViewCompositionDemos
//
//  Created by Mohammad Azam on 10/18/25.
//

import SwiftUI
import UIKit

extension View {
    
    func rounded(radius: CGFloat = 16, style: RoundedCornerStyle = .continuous) -> some View {
        return self.clipShape(RoundedRectangle(cornerRadius: radius, style: style))
    }
    
}

struct CircularProgressView: View {
    /// 0.0 ... 1.0
    var progress: CGFloat
    var lineWidth: CGFloat = 10
    var showsPercentage: Bool = true
    var roundedCaps: Bool = true
    var trackColor: Color = .gray.opacity(0.2)
    var gradient: AngularGradient = .init(
        gradient: .init(colors: [.blue, .purple, .pink, .blue]),
        center: .center
    )

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)

            // Progress ring
            Circle()
                .trim(from: 0, to: max(0, min(1, progress)))
                .stroke(
                    gradient,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: roundedCaps ? .round : .butt
                    )
                )
                .rotationEffect(.degrees(-90)) // start at top
                .animation(.easeInOut(duration: 0.35), value: progress)

            if showsPercentage {
                Text("\(Int((max(0, min(1, progress)) * 100).rounded()))%")
                    //.font(.system(.title2, design: .rounded).monospacedDigit())
                    .bold()
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.2), value: progress)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int((max(0, min(1, progress)) * 100).rounded())) percent")
    }
}

struct Customer: Identifiable {
    let id = UUID()
    let name: String
    let imageURL: URL?
}

enum ViewPlacement {
    case leading
    case trailing
}

struct ListCellView<Leading: View, Trailing: View>: View {
    
    let title: String
    var subTitle: String?
    var imageURL: URL?
    var imagePlacement: ViewPlacement? = .leading
    @ViewBuilder var leadingAccessoryView: () -> Leading
    @ViewBuilder var trailingAccessoryView: () -> Trailing
    
    init(title: String, subTitle: String? = nil, imageURL: URL? = nil, imagePlacement: ViewPlacement? = .leading, leadingAccessoryView: @escaping () -> Leading = { EmptyView() }, trailingAccessoryView: @escaping () -> Trailing = { EmptyView() }) {
        self.title = title
        self.subTitle = subTitle
        self.imageURL = imageURL
        self.imagePlacement = imagePlacement
        self.leadingAccessoryView = leadingAccessoryView
        self.trailingAccessoryView = trailingAccessoryView
    }
    
    private var imageView: some View {
        AsyncImage(url: imageURL) { img in
            img.resizable()
                .frame(width: 50, height: 50)
                .rounded()
                .shadow(color: .black.opacity(0.25), radius: 6)
                
        } placeholder: {
            ProgressView("Loading...")
        }
    }
    
    var body: some View {
        HStack {
            
            leadingAccessoryView()
            
            if imagePlacement == .leading {
                imageView
            }
            
            VStack {
                Text(title)
                if let subTitle {
                    Text(subTitle)
                }
            }
            
            Spacer()
            
            if imagePlacement == .trailing {
                imageView
            }
            
            trailingAccessoryView()
        }
    }
}

/*
struct CustomerCellView: View {
    
    let customer: Customer
    
    var body: some View {
        HStack {
            AsyncImage(url: customer.imageURL) { img in
                img.resizable()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            
            Text(customer.name)
        }
    }
} */

struct CustomerListView: View {
    
    let customers: [Customer]
    @State private var value: CGFloat = 0.25
    
    var body: some View {
        List(customers) { customer in
            ListCellView(title: customer.name, imageURL: customer.imageURL, trailingAccessoryView: {
                CircularProgressView(progress: value)
                    .frame(width: 50, height: 50)
            })
        }
    }
}

struct ContentView: View {
    
    let customers: [Customer] = [
        .init(name: "Olivia Bennett", imageURL: URL(string: "https://randomuser.me/api/portraits/women/44.jpg")!),
        .init(name: "Noah Peterson", imageURL: URL(string: "https://randomuser.me/api/portraits/men/32.jpg")!),
        .init(name: "Amelia Davis", imageURL: URL(string: "https://randomuser.me/api/portraits/women/68.jpg")!),
        .init(name: "Liam Martinez", imageURL: URL(string: "https://randomuser.me/api/portraits/men/57.jpg")!),
        .init(name: "Emma Johnson", imageURL: URL(string: "https://randomuser.me/api/portraits/women/3.jpg")!)
    ]
    
    var body: some View {
        CustomerListView(customers: customers)
    }
}

#Preview {
    ContentView()
}



// MARK: - Preview Helpers
private let sampleURL = URL(string: "https://randomuser.me/api/portraits/men/32.jpg")!

private struct DotStatus: View {
    var color: Color = .green
    var body: some View {
        Circle().frame(width: 10, height: 10).foregroundStyle(color)
    }
}

// MARK: - 1) Basic: title + leading image (default)
#Preview("Basic - Leading Image") {
    ListCellView(title: "Olivia Bennett",
                 subTitle: "Pro Member",
                 imageURL: sampleURL)
        .padding()
        .previewLayout(.sizeThatFits)
}

// MARK: - 2) Trailing image instead of leading
#Preview("Trailing Image") {
    ListCellView(title: "Noah Peterson",
                 subTitle: "Active since 2022",
                 imageURL: sampleURL,
                 imagePlacement: .trailing)
        .padding()
        .previewLayout(.sizeThatFits)
}

// MARK: - 3) Leading accessory (status dot) + default leading image
#Preview("Leading Accessory") {
    ListCellView(title: "Amelia Davis",
                 subTitle: "Online",
                 imageURL: sampleURL,
                 leadingAccessoryView: {
                     DotStatus(color: .green)
                         .padding(.trailing, 4)
                 })
        .padding()
        .previewLayout(.sizeThatFits)
}

// MARK: - 4) Trailing accessory (progress ring)
#Preview("Trailing Accessory - Progress") {
    ListCellView(title: "Liam Martinez",
                 subTitle: "Course progress",
                 imageURL: sampleURL,
                 trailingAccessoryView: {
                     CircularProgressView(progress: 0.62)
                         .frame(width: 40, height: 40)
                 })
        .padding()
        .previewLayout(.sizeThatFits)
}

// MARK: - 5) Both accessories (star on left, chevron on right)
#Preview("Both Accessories") {
    ListCellView(title: "Emma Johnson",
                 subTitle: "Favorite",
                 imageURL: sampleURL,
                 leadingAccessoryView: {
                     Image(systemName: "star.fill")
                         .imageScale(.large)
                         .foregroundStyle(.yellow)
                         .padding(.trailing, 6)
                 },
                 trailingAccessoryView: {
                     Image(systemName: "chevron.right")
                         .font(.headline)
                         .foregroundStyle(.secondary)
                 })
        .padding()
        .previewLayout(.sizeThatFits)
}

// MARK: - 6) No image, trailing toggle
#Preview("No Image + Toggle") {
    @State var isOn = true
    return ListCellView(title: "Notifications",
                        subTitle: "Marketing updates",
                        trailingAccessoryView: {
                            Toggle("", isOn: $isOn)
                                .labelsHidden()
                        })
    .padding()
    .previewLayout(.sizeThatFits)
}

// MARK: - 7) In a List with mixed styles
#Preview("List - Mixed Cells") {
    List {
        ListCellView(title: "Primary Account",
                     subTitle: "Ending •••• 4242",
                     imageURL: sampleURL,
                     leadingAccessoryView: {
                         Image(systemName: "creditcard.fill")
                             .foregroundStyle(.blue)
                             .padding(.trailing, 6)
                     },
                     trailingAccessoryView: {
                         Text("Default")
                             .font(.caption)
                             .padding(.horizontal, 8)
                             .padding(.vertical, 4)
                             .background(.blue.opacity(0.1), in: Capsule())
                     })

        ListCellView(title: "Storage",
                     subTitle: "62% used of 200 GB",
                     trailingAccessoryView: {
                         CircularProgressView(progress: 0.62)
                             .frame(width: 36, height: 36)
                     })

        ListCellView(title: "Security",
                     subTitle: "2FA enabled",
                     leadingAccessoryView: {
                         DotStatus(color: .green)
                             .padding(.trailing, 6)
                     },
                     trailingAccessoryView: {
                         Image(systemName: "chevron.right")
                             .foregroundStyle(.secondary)
                     })
    }
}

