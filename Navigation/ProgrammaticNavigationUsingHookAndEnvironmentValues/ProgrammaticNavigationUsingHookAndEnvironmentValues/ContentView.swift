//
//  ProgrammaticNavigationUsingNavigateHook.swift
//  SwiftUIArchitectureBook
//
//  Created by Mohammad Azam on 8/24/25.
//

import SwiftUI

struct DoctorListScreen: View {
    var body: some View { Text("Doctors") }
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
    case list
    case details(UUID)
    case schedule(patientID: UUID, date: Date)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .list:
            PatientListScreen()
        case .details(let id):
            PatientDetailScreen(patientID: id)
        case .schedule(let patientID, let date):
            PatientScheduleScreen(patientID: patientID, date: date)
        }
    }
}

struct NavigateAction {
    typealias Action = (Route) -> ()
  
    let action: Action
    
    func callAsFunction(_ route: Route) {
        action(route)
    }
}

extension EnvironmentValues {
    @Entry var navigate = NavigateAction { _ in }
}

struct HomeScreen: View {
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack {
            Button("Doctor List Screen") {
                navigate(.doctor(.list))
            }
            
            Button("Patient Detail Screen") {
                navigate(.patient(.details(UUID())))
            }
              
        }
    }
}

struct ContentView: View {
    
    @State private var routes: [Route] = []
    
    var body: some View {
        NavigationStack(path: $routes) {
            HomeScreen()
                .navigationDestination(for: Route.self) { route in
                    route.destination
                }
        }.environment(\.navigate, NavigateAction(action: { route in
            routes.append(route)
        }))
       
    }
}

#Preview {
     ContentView()
}
