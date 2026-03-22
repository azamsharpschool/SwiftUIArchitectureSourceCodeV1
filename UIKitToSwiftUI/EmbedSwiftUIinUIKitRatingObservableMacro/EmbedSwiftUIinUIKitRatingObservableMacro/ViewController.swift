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

@Observable
class Rating {
    var value: Int?
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
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(40.0)
        return label
    }()
    
    lazy var clearRatingButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Clear Rating", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(clearRatingTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func clearRatingTapped() {
        rating.value = nil                     // Reset the rating
        ratingLabel.text = ""                 // Update label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let binding = Binding<Int?> { [weak self] in
            return self?.rating.value
        } set: { [weak self] newValue in
            self?.rating.value = newValue
            self?.ratingLabel.text = newValue.map { "\($0)" }
        }
        
        let hostingController = UIHostingController(rootView: RatingView(rating: binding))
        
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
