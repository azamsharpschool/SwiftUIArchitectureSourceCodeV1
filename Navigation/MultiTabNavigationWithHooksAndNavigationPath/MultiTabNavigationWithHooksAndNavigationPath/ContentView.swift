//
//  MultipleTabsWithHooksAndNavigationPathScreen.swift
//  SwiftUIArchitectureBook
//
//  Created by Mohammad Azam on 8/24/25.
//

import SwiftUI

struct NavigateAction {
    typealias Action = (Route) -> ()
    typealias PopToRoot = () -> Void
    
    let action: Action
    let popToRoot: PopToRoot
    
    func callAsFunction(_ route: Route) {
        action(route)
    }
}

extension EnvironmentValues {
    @Entry var navigate = NavigateAction { _ in } popToRoot: { }
}

struct PatientScreen: View {
    
    //@Environment(MultiTabRouter.self) private var router
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        Button("Go to Patient Detail Screen") {
            navigate(.patient(.details(UUID())))
            //router.patientRoutes.append(.details(UUID()))
        }
        
        Button("Go to Doctor Detail Screen") {
            navigate(.doctor(.details(UUID())))
            //router.patientRoutes.append(.details(UUID()))
        }
    }
}

struct DoctorScreen: View {
    var body: some View {
        Text("Doctor Screen")
    }
}

struct DoctorListScreen: View {
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack {
            Text("DoctorListScreen")
            
            Button("Pop to Root View") {
                navigate.popToRoot()
            }
        }
    }
}

struct DoctorDetailScreen: View {
    let doctorID: UUID
    var body: some View { Text("Doctor \(doctorID.uuidString.prefix(6))") }
}

struct DoctorScheduleScreen: View {
    let doctorID: UUID
    let date: Date
    var body: some View { Text("Schedule for \(doctorID.uuidString.prefix(6)) on \(date.formatted())") }
}

struct PatientListScreen: View {
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack {
            Text("PatientListScreen")
            Button("Go DoctorListScreen") {
                navigate(.doctor(.list))
            }
        }
    }
}

struct PatientDetailScreen: View {
    let patientID: UUID
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack {
            Text("PatientDetailScreen")
            Text("Patient \(patientID.uuidString.prefix(6))")
            
            Button("Go to Patient List Screen") {
                navigate(.patient(.list))
            }
        }
    }
}

struct PatientScheduleScreen: View {
    let patientID: UUID
    let date: Date
    var body: some View { Text("Schedule for \(patientID.uuidString.prefix(6)) on \(date.formatted())") }
}

enum Route: Hashable {
    case doctor(DoctorRoute)
    case patient(PatientRoute)
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .doctor(let doctorRoute):
                doctorRoute.destination
            case .patient(let patientRoute):
                patientRoute.destination
        }
        
    }
}

enum DoctorRoute: Hashable {
    case list
    case details(UUID)
    case schedule(doctorID: UUID, date: Date)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .list:
            DoctorListScreen()
        case .details(let id):
            DoctorDetailScreen(doctorID: id)
        case .schedule(let doctorID, let date):
            DoctorScheduleScreen(doctorID: doctorID, date: date)
        }
    }
}

enum PatientRoute: Hashable {
    case home
    case list
    case details(UUID)
    case schedule(patientID: UUID, date: Date)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            PatientScreen()
        case .list:
            PatientListScreen()
        case .details(let id):
            PatientDetailScreen(patientID: id)
        case .schedule(let patientID, let date):
            PatientScheduleScreen(patientID: patientID, date: date)
        }
    }
}

enum AppTab: Hashable, Identifiable, CaseIterable {
    case patients
    case doctors
    
    var id: AppTab { self }
}

extension AppTab {
    
    var title: String {
        switch self {
        case .patients:
            return "Patients"
            //Label("Patients", systemImage: "heart")
        case .doctors:
            return "Doctors"
            //Label("Doctors", systemImage: "star")
        }
    }
    
    var icon: String {
        switch self {
        case .patients:
            return "heart"
        case .doctors:
            return "star"
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .patients:
            PatientScreen()
        case .doctors:
            DoctorScreen()
        }
    }
    
}


struct ContentView: View {
    
    @State private var selectedTab: AppTab = .patients
    @State private var routes: [AppTab: NavigationPath] = [: ]
    
    private func binding(for tab: AppTab) -> Binding<NavigationPath> {
        Binding(
            get: { routes[tab, default: NavigationPath()] },
            set: { routes[tab] = $0 }
        )
    }
    
    var body: some View {
    
        TabView(selection: $selectedTab) {
            
            ForEach(AppTab.allCases) { tab in
                Tab(tab.title, systemImage: tab.icon, value: tab) {
                    NavigationStack(path: binding(for: tab)) {
                        tab.destination
                            .navigationDestination(for: Route.self) { route in
                                route.destination
                            }
                    }
                }
            }
            
        }.environment(\.navigate, NavigateAction(action: { route in
            var navigationPath = routes[selectedTab, default: NavigationPath()]
            navigationPath.append(route)
            routes[selectedTab] = navigationPath
        
    }, popToRoot: {
        routes[selectedTab] = NavigationPath()
    }))
    }
}



#Preview {
    ContentView()
}
