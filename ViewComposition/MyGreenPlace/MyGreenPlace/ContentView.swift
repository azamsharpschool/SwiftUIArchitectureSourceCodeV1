//
//  ContentView.swift
//  MyGreenPlace
//
//  Created by Mohammad Azam on 1/23/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var count: Int = 0
    @State private var expanded: Bool = false
    
    var body: some View {
        VStack {
            Image("mountains")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .watermark()
            
            Text("\(count)")
            
            Button("Increment") {
                count += 1
            }
                
        }
    }
}

extension View {
    
    func watermark() -> some View {
        modifier(Watermark())
    }
    
}

struct Watermark: ViewModifier {
    
    @State private var expanded: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                TimelineView(.periodic(from: .now, by: 1)) { timeline in
                    Text("\(timeline.date.formatted(date: expanded ? .complete: .omitted, time: expanded ? .complete: .standard))")
                        .font(.caption)
                        .padding(8)
                        .background(.black.opacity(0.5))
                        .foregroundColor(.white)
                        .onTapGesture {
                            expanded.toggle()
                        }
                }
                
            }
    }
}



#Preview {
    ContentView()
}



