//
//  ViewController.swift
//  DI
//
//  Created by Rehnuma Reza(Deepty) on 6/2/25.
//

import UIKit
import APIKit
import ChartUIKit

extension APIService: DiseaseDataFetchable {}

class ViewController: UIViewController {
    var diseaseData: Disease?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    public func setupUI() {
        let button = UIButton(frame: .zero)
        button.setTitle("View covid cases summary", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showDiseases), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func showDiseases() {
        let vc = DiseaseDataViewController(diseaseFetchable: APIService.shared)
        present(vc, animated: true)
    }
}

