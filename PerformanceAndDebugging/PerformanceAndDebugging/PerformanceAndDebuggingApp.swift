//
//  PerformanceAndDebuggingApp.swift
//  PerformanceAndDebugging
//
//  Created by Mohammad Azam on 10/28/25.
//

import SwiftUI



@main
struct PerformanceAndDebuggingApp: App {
    var body: some Scene {
        WindowGroup {
            CustomerListScreen()
                .task {
                    // perform work here.
                }
        }
    }
}
