//
//  ContentView.swift
//  GlobalSheets
//
//  Created by Mohammad Azam on 8/28/25.
//

import SwiftUI

enum Sheet: Identifiable, Hashable {
    case settings
    case contact(String)
    
    var id: Self { self }
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .settings:
                Text("Settings")
            case .contact(let name):
                Text("Contact \(name)")
        }
    }
}

struct SheetAction {
    typealias Action = (Sheet) -> Void
    let action: Action
    
    func callAsFunction(_ sheet: Sheet) {
        action(sheet)
    }
}

extension EnvironmentValues {
    @Entry var showSheet = SheetAction { _ in }
}

struct ContentView: View {
    
    @Environment(\.showSheet) private var showSheet
    
    var body: some View {
        VStack {
            Button("Show Settings") {
                showSheet(.settings)
            }
            
            Button("Show Contact") {
                showSheet(.contact("John Doe"))
            }
        }
        .padding()
    }
}

#Preview {
    
    @Previewable @State var selectedSheet: Sheet? = nil
    
    ContentView()
        .environment(\.showSheet, SheetAction(action: { sheet in
            selectedSheet = sheet
        })).sheet(item: $selectedSheet) { sheet in
            sheet.destination
        }
}
