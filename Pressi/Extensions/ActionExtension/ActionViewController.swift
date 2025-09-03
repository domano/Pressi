//
//  ActionViewController.swift
//  Pressi Action Extension
//
//  Minimal placeholder for an Action Extension.
//

import UIKit

final class ActionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pressi Action"
        label.font = .preferredFont(forTextStyle: .headline)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

