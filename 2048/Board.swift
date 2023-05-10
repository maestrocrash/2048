//
//  Board.swift
//  2048
//
//  Created by MICHAIL SHAKHVOROSTOV on 05.05.2023.
//

import UIKit

class Board {
    let boardView : UIView
    var tileArray = [Tile]()
    
    init() {
        boardView = UIView(frame: .zero)
        boardView.backgroundColor = style.boardBackgroundColor
        boardView.layer.cornerRadius = 6
        boardView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pointAt(x:Int, y:Int) -> CGPoint {
        let offsetX = config.borderSize.width
        let offsetY = config.borderSize.height
        let width = config.tileSize.width + config.borderSize.width
        let height = config.tileSize.height + config.borderSize.height
        return CGPoint(x: offsetX + width * CGFloat(x), y: offsetY + height * CGFloat(y))
    }
    
    func pointAt(position:Position) -> CGPoint {
        return pointAt(x: position.x, y: position.y)
    }
    
    func addTo(view : UIView){
        view.addSubview(self.boardView)
        boardView.widthAnchor.constraint(equalToConstant: config.boardSize.width).isActive = true
        boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor).isActive = true
        boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func gameOver() {
        print("game over")
    }
    
    func add(tile:Tile) {
        tile.addTo(board: self)
        tileArray.append(tile)
    }
    
    func generateTile() {
        guard tileArray.count <= config.tileCount else {
            print("no space available")
            return
        }
        
        var tileList : [(Int,Int)?] = Array(repeating: nil, count: config.tileCount)
        for x in 0..<config.tileNumber {
            for y in 0..<config.tileNumber {
                tileList[x+y*config.tileNumber] = (x,y)
            }
        }
        for tile in tileArray {
            tileList[tile.position.x + tile.position.y * config.tileNumber] = nil
        }
        let remain = tileList.compactMap {$0}
        let random = arc4random_uniform(UInt32(remain.count))
        let value = Int(arc4random_uniform(3)/2)+1
        let (x, y) = remain[Int(random)]
        let tile = Tile(value: value, position: Position(x: x, y: y))
        
        tile.addTo(board: self)
        tileArray.append(tile)
    }
    
    func buildBoard() {
        for i in 0..<4 {
            for j in 0..<4 {
                let layer = CALayer()
                layer.frame = CGRect(origin: pointAt(x: i, y: j), size: config.tileSize)
                layer.backgroundColor = style.emptyTileBackgroundColor.cgColor
                layer.cornerRadius = 3
                boardView.layer.addSublayer(layer)
            }
        }
        generateTile()
        generateTile()
    }
    
    func removeFromTileArray(tile:Tile) {
        if let idx = tileArray.firstIndex(where: {$0 == tile}) {
            tileArray.remove(at: idx)
            tile.removeFromBoard()
        }
    }
    func checkMovement(direction:Direction, orientation:Orientation) -> Bool {
        var moved = false
        var tileList = [Tile]()
        for y in 0..<config.tileNumber {
            for x in 0..<config.tileNumber {
                let tile = Tile(value: 0, position: Position(x: x, y: y))
                tileList.append(tile)
            }
        }
        for tile in tileArray {
            tileList[tile.position.x + tile.position.y * config.tileNumber] = tile
        }
        var lastZeroTile : Tile? = nil
        var lastMergableTile : Tile? = nil
        for i in 0..<config.tileNumber {
            lastZeroTile = nil
            lastMergableTile = nil
            for j in 0..<config.tileNumber {
                let temp = direction == .forward ? (config.tileNumber - 1) - j : j
                let x = orientation == .horizon ? temp : i
                let y = orientation == .horizon ? i : temp
                let tile = tileList[x + y * config.tileNumber]
                if !tile.isEmpty {
                    if let mergableTile = lastMergableTile, mergableTile.value == tile.value {
                        tile.mergeTo(position: mergableTile.position)
                        removeFromTileArray(tile: mergableTile)
                        lastMergableTile = nil
                        lastZeroTile = tile.createPreviousEmptyTile(direction: direction, orientation: orientation)
                        moved = true
                        continue
                    }
                    if let zeroTile = lastZeroTile {
                       
                        tile.moveTo(position: zeroTile.position)
                        lastZeroTile = tile.createPreviousEmptyTile(direction: direction, orientation: orientation)
                        moved = true
                    }
                    lastMergableTile = tile
                   
                } else {
                    if lastZeroTile == nil {
                        lastZeroTile = tile
                    }
                }
            }
        }
        return moved
    }
    
    func moveTile(direction: Direction, orientation: Orientation) {
        let moved = checkMovement(direction: direction, orientation: orientation)
        print(moved)
        UIView.animate(withDuration: 0.1, animations: {
            self.boardView.layoutIfNeeded()
        }) { (_) in
            if moved {
                self.generateTile()
            }
        }
    }
}
