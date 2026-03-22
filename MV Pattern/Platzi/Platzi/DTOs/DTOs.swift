//
//  DTOs.swift
//  Platzi
//
//  Created by Mohammad Azam on 9/14/25.
//

import Foundation
import MapKit

struct Category: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let slug: String
    let image: URL
}

struct Location: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
