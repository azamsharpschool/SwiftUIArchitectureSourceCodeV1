//
//  ViewController.swift
//  EmbedUIKitViewsInSwiftUIApp
//
//  Created by Mohammad Azam on 10/12/25.
//

import UIKit
import SwiftUI
import Combine

struct StarRatingView: UIViewRepresentable {
    @Binding var rating: Int

    func makeUIView(context: Context) -> SimpleStarRating {
        let view = SimpleStarRating() // UIKit view
        view.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return view
    }
    
    func updateUIView(_ uiView: SimpleStarRating, context: Context) {
        if uiView.rating != rating {
            uiView.rating = rating
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(rating: $rating)
    }

    final class Coordinator: NSObject {
        var rating: Binding<Int>
        init(rating: Binding<Int>) { self.rating = rating }
        @objc func valueChanged(_ sender: SimpleStarRating) {
            rating.wrappedValue = sender.rating
        }
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: SimpleStarRating, context: Context) -> CGSize? {
        uiView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

struct ContentView: View {
    
    @State private var rating: Int = 2
    
    var body: some View {
       StarRatingView(rating: $rating)
    }
}

#Preview {
    ContentView()
}

final class SimpleStarRating: UIControl {

    var rating: Int = 0 {
        didSet { updateStars(); sendActions(for: .valueChanged) }
    }

    private let stack = UIStackView()
    private var buttons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        for i in 1...5 {
            let b = UIButton(type: .system)
            b.tag = i
            b.setImage(UIImage(systemName: "star"), for: .normal)
            b.tintColor = .systemOrange
            b.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
            buttons.append(b)
            stack.addArrangedSubview(b)
        }
        updateStars()
    }

    @objc private func tap(_ sender: UIButton) {
        rating = sender.tag
    }

    private func updateStars() {
        for b in buttons {
            let name = b.tag <= rating ? "star.fill" : "star"
            b.setImage(UIImage(systemName: name), for: .normal)
        }
    }
}


class ViewController: UIViewController {

    // Inside your view controller
    lazy var starRating: SimpleStarRating = {
        let view = SimpleStarRating()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(ratingChanged(_:)), for: .valueChanged)
        return view
    }()
    
    @objc private func ratingChanged(_ control: SimpleStarRating) {
        print("rating:", control.rating)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(starRating)

        NSLayoutConstraint.activate([
            starRating.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starRating.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

#Preview {
    ViewController()
}

