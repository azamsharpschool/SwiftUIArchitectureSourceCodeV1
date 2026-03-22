//
//  ProgrammaticNavigationLoginScreen.swift
//  SwiftUIArchitectureBook
//
//  Created by Mohammad Azam on 8/23/25.
//

import SwiftUI
import Observation

@Observable
class Router {
    var routes: [Route] = []
}

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

struct PatientListScreen: View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack {
            Text("PatientListScreen")
            Button("Go to PatientDetailScreen") {
                router.routes.append(.patient(.details(UUID())))
            }
        }
    }
}

struct PatientDetailScreen: View {
    let patientID: UUID
    
    var body: some View {
        VStack {
            Text("Patient \(patientID.uuidString.prefix(6))")
        }
    }
}

struct PatientScheduleScreen: View {
    let patientID: UUID
    let date: Date
    var body: some View { Text("Schedule for \(patientID.uuidString.prefix(6)) on \(date.formatted())") }
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


struct ContentView: View {
    
    //@State private var routes: [Route] = []
    @Environment(Router.self) private var router

    
    var body: some View {
        
        @Bindable var router = router
        
        NavigationStack(path: $router.routes) {
            VStack {
                Button("DoctorsListScreen") {
                    // perform some time consuming operation
                    Task {
                        try! await Task.sleep(for: .seconds(2.0))
                        router.routes.append(.doctor(.list))
                    }
                }
                
                Button("PatientsListScreen") {
                    // perform some time consuming operation
                    Task {
                        try! await Task.sleep(for: .seconds(2.0))
                        router.routes.append(.patient(.list))
                    }
                }
            }.navigationDestination(for: Route.self) { route in
                route.destination
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Router())
}
