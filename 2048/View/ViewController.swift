//
//  ViewController.swift
//  2048
//
//  Created by MICHAIL SHAKHVOROSTOV on 05.05.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraint()
    }

    let buttonStart = CustomButton(text: "Start game")
}



extension ViewController {
    private func setupView() {
        buttonStart.addTarget(self, action: #selector(tapButtonStart), for: .touchUpInside)
        view.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.6235294118, blue: 0.5607843137, alpha: 1)
        view.addSubview(buttonStart)
    }
    
    @objc private func tapButtonStart() {
        let vc = GameScreen()
        navigationController?.show(vc, sender: .none)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            buttonStart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStart.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
}
