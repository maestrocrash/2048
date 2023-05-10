//
//  CustomButton.swift
//  2048
//
//  Created by MICHAIL SHAKHVOROSTOV on 05.05.2023.
//

import UIKit

class CustomButton: UIButton {
    
    private var config = Configuration.filled()
    private var animator = UIViewPropertyAnimator()
    
    
    init(text: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter, .touchUpInside])
        addTarget(self, action: #selector(animateUP), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        
        config.image = UIImage(systemName: "arrow.forward.circle.fill")
        config.baseBackgroundColor = #colorLiteral(red: 0.9098039216, green: 0.737254902, blue: 0.03921568627, alpha: 1)
        config.imagePadding = 10
        config.title = text
        config.imagePlacement = .trailing
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        configuration = config
    }
    
    @objc private func animateDown() {
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        animator.startAnimation()
    }
    
    @objc private func animateUP() {
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
            self.transform = .identity
        })
        
        animator.startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
