//
//  CustomerDetailsViewController.swift
//  EmbedSwiftUIInUIKit
//
//  Created by Mohammad Azam on 10/11/25.
//

// This example shows how to embded and communicate with the RatingsView

import Foundation
import UIKit
import SwiftUI
import Observation
import Combine // REQUIRED


class Rating: ObservableObject {
    @Published var value: Int?
}

struct RatingViewContainer: View {
    
    @ObservedObject var rating: Rating
    
    var body: some View {
        RatingView(rating: $rating.value)
    }
}

struct RatingView: View {
    
    @Binding var rating: Int?
    
    private func starType(index: Int) -> String {
        
        if let rating = self.rating {
            return index <= rating ? "star.fill" : "star"
        } else {
            return "star"
        }
    }
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: self.starType(index: index))
                    .foregroundColor(Color.orange)
                    .onTapGesture {
                        self.rating = index
                    }
            }
        }
    }
}


class CustomerDetailsViewController: UIViewController {
    
    var rating: Rating = Rating()
    var cancellables: AnyCancellable?
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(40.0)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancellables = rating.$value.sink { [weak self] rating in
            if let rating {
                self?.ratingLabel.text = "\(rating)"
            }
        }
        
        let hostingController = UIHostingController(rootView: RatingViewContainer(rating: rating))
        
        guard let ratingView = hostingController.view else { return }
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(hostingController)
        self.view.addSubview(ratingView)
        self.view.addSubview(ratingLabel)
        
        hostingController.didMove(toParent: self)
        
        ratingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ratingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ratingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
    }
}

#Preview {
    CustomerDetailsViewController()
}
