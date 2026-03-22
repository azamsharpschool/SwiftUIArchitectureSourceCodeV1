//
//  ContentView.swift
//  SwiftUIProfiling
//
//  Created by Mohammad Azam on 2/12/26.
//

import Foundation
import Observation
import SwiftUI

struct ContentView: View {
    var body: some View {
        MinimalTimerView()
    }
}

struct MinimalTimerView: View {
    @State private var tick = 0
    @State private var timer: Timer?
    @State private var service = HeavyComputationService()
    
    var body: some View {
        let checksum = service.heavyComputation(tick)

        Text("Tick: \(tick) • \(checksum)")
            .font(.headline)
            .padding()
            .onAppear {
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                    tick += 1
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
    }

}

@Observable
final class HeavyComputationService {
    @inline(never)
    func heavyComputation(_ value: Int) -> Int {
        var hash = 0
        for i in 0..<80_000 {
            hash = (hash &* 31) &+ (i ^ value)
        }
        return hash
    }
}

import SwiftUI

struct HangExampleView: View {

    @State private var message = "Tap the button"

    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.headline)

            Button("Perform Heavy Work") {
                Task {
                    await performHeavyWork()
                }
            }
        }
        .padding()
    }

    func performHeavyWork() async {
        await Task.detached(priority: .userInitiated) {
            var count = 0
            for _ in 0..<200_000_000 {
                count += 1
            }

            await MainActor.run {
                message = "Finished"
            }
        }.value
    }
}

#Preview {
    HangExampleView()
}

