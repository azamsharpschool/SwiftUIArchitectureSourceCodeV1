//
//  MoviesApp.swift
//  Movies
//
//  Created by Mohammad Azam on 1/3/26.
//

import SwiftUI

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListScreen(vm: MovieListViewModel(httpClient: HTTPClient()))
        }
    }
}
