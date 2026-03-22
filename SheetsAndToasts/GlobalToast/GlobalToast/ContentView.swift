
//
//  ContentView.swift
//  ToastMessageDemo
//
//  Created by Mohammad Azam on 4/24/25.
//

import SwiftUI

enum ToastType {
    case success(String)
    case error(String)
    case info(String)
    
    var backgroundColor: Color {
        switch self {
            case .success:
                return Color.green.opacity(0.9)
            case .error:
                return Color.red.opacity(0.9)
            case .info:
                return Color.blue.opacity(0.9)
        }
    }
    
    var icon: Image {
        switch self {
            case .success:
                return Image(systemName: "checkmark.circle")
            case .error:
                return Image(systemName: "xmark.octagon")
            case .info:
                return Image(systemName: "info.circle")
        }
    }
    
    var message: String {
        switch self {
            case .success(let msg), .error(let msg), .info(let msg):
                return msg
        }
    }
    
}

struct ToastView: View {
    
    let type: ToastType
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            type.icon
                .foregroundStyle(.white)
            Text(type.message)
                .foregroundColor(.white)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }  .padding()
            .background(type.backgroundColor)
            .cornerRadius(12)
            .shadow(radius: 4)
            .padding(.horizontal, 16)
    }
}

#Preview {
    ToastView(type: .success("Customer saved."))
    ToastView(type: .error("Operation failed."))
    ToastView(type: .info("Informational message."))
}

struct ShowToastAction {
    typealias Action = (ToastType, ToastPlacement, TimeInterval) -> Void
    let action: Action
    
    func callAsFunction(_ type: ToastType, placement: ToastPlacement = .top, disappearAfter: TimeInterval = 2.0) {
        action(type, placement, disappearAfter)
    }
}

enum ToastPlacement {
    case top
    case bottom
}

extension EnvironmentValues {
    @Entry var showToast = ShowToastAction(action: { _, _, _  in })
}

struct ToastModifier: ViewModifier {
    
    @State private var type: ToastType?
    @State private var placement: ToastPlacement = .top
    @State private var disappearAfter: TimeInterval = 2.0
    @State private var dismissTask: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .environment(\.showToast, ShowToastAction(action: { type, placement, disappearAfter in
                withAnimation(.easeInOut) {
                    self.type = type
                    self.placement = placement
                    self.disappearAfter = disappearAfter
                    
                }
                
                // cancel previous dismissal task if any
                dismissTask?.cancel()
                
                // schedule a new dismisal
                let task = DispatchWorkItem {
                    withAnimation(.easeInOut) {
                        self.type = nil
                    }
                }
                
                self.dismissTask = task
                DispatchQueue.main.asyncAfter(deadline: .now() + disappearAfter, execute: task)
                
            }))
            .overlay(alignment: placement == .top ? .top: .bottom) {
                if let type {
                    ToastView(type: type)
                        .transition(.move(edge: placement == .top ? .top: .bottom).combined(with: .opacity))
                        .padding(.top, 50)
                }
            }
    }
}

extension View {
    func withToast() -> some View {
        modifier(ToastModifier())
    }
}

struct SettingsScreen: View {
    
    @Environment(\.showToast) private var showToast
    
    var body: some View {
        VStack {
            Button("Success") {
                showToast(.success("Success"), placement: .bottom)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView: View {
    
    @Environment(\.showToast) private var showToast
    @State private var settingsPresented: Bool = false
    
    var body: some View {
        VStack {
            
            Button("Success") {
                showToast(.success("Success"), placement: .bottom)
            }
            
            Button("Error") {
                showToast(.error("Operation failed."), placement: .top)
            }
            
            Button("Info") {
                showToast(.info("Informational message"), placement: .top, disappearAfter: 5.0)
            }
            
            Button("Show Settings") {
                settingsPresented = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .sheet(isPresented: $settingsPresented) {
            SettingsScreen()
                .withToast()
        }
       
    }
}



#Preview {
    ContentView()
        .withToast()
}
