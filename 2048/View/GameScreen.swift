//
//  GameScreen.swift
//  2048
//
//  Created by MICHAIL SHAKHVOROSTOV on 05.05.2023.
//


import UIKit


class GameScreen: UIViewController {
    
    let board = Board()
    
    @IBAction func swipe(recognizer:UIGestureRecognizer?) {
        guard let recognizer = recognizer as? UISwipeGestureRecognizer else {
            return
        }
        switch recognizer.direction {
        case UISwipeGestureRecognizer.Direction.right:
            board.moveTile(direction: .forward, orientation: .horizon)
      
        case UISwipeGestureRecognizer.Direction.left:
            board.moveTile(direction: .backward, orientation: .horizon)
           
        case UISwipeGestureRecognizer.Direction.up:
            board.moveTile(direction: .backward, orientation: .vertical)
          
        case UISwipeGestureRecognizer.Direction.down:
            board.moveTile(direction: .forward, orientation: .vertical)
           
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        if let view = self.view {
            view.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.6235294118, blue: 0.5607843137, alpha: 1)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            for direction : UISwipeGestureRecognizer.Direction in [.left, .right, .up, .down] {
                let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
                gesture.direction = direction
                view.addGestureRecognizer(gesture)
            }
            
            board.addTo(view: view)
            board.buildBoard()
        }
    }
    
}
