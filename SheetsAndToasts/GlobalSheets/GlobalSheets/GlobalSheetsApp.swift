//
//  GlobalSheetsApp.swift
//  GlobalSheets
//
//  Created by Mohammad Azam on 8/28/25.
//

import SwiftUI

@main
struct GlobalSheetsApp: App {
    
    @State var selectedSheet: Sheet? = nil
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.showSheet, SheetAction(action: { sheet in
                    selectedSheet = sheet
                })).sheet(item: $selectedSheet) { sheet in
                    sheet.destination
                }
        }
    }
}
