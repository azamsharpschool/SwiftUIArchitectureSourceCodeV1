//
//  ViewModifierDemo.swift
//  ViewCompositionDemos
//
//  Created by Mohammad Azam on 10/19/25.
//

import SwiftUI


struct Watermark: ViewModifier {
    
    @State private var expanded: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                
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

/*
 struct Watermark: ViewModifier {
 @State private var time = Date()
 let formatter: DateFormatter = {
 let f = DateFormatter()
 f.timeStyle = .medium
 return f
 }()
 
 func body(content: Content) -> some View {
 content
 .overlay(alignment: .bottomTrailing) {
 Text(formatter.string(from: time))
 .font(.caption)
 .padding(8)
 .background(.black.opacity(0.5))
 .foregroundColor(.white)
 .onAppear {
 Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
 time = Date()
 }
 }
 }
 }
 } */

extension View {
    
    func watermark() -> some View {
        modifier(Watermark())
    }
}

struct WatermarkExample: View {
    
    @State private var showWatermark: Bool = false
    
    var body: some View {
        VStack {
            Image("building")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .watermark()
            Text("Photo by Sean Pollock on Unsplash")
                .font(.caption)
            
            Button(showWatermark ? "Hide Watermark": "Show Watermark") {
                showWatermark.toggle()
            }.font(.caption2)
        }
    }
}

#Preview {
    WatermarkExample()
}



struct GlowOnPressModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .shadow(color: isPressed ? .blue.opacity(0.7) : .clear, radius: 15)
            .scaleEffect(isPressed ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .gesture(
                LongPressGesture(minimumDuration: 0.2)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    func glowOnPress() -> some View {
        modifier(GlowOnPressModifier())
    }
}

struct GlowExample: View {
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 60))
            .foregroundColor(.pink)
            .glowOnPress()
    }
}

#Preview {
    GlowExample()
}


