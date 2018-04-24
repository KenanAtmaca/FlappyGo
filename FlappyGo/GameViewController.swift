//
//  GameViewController.swift
//  FlappyGo
//
//  Created by Kenan Atmaca on 31.03.2018.
//  Copyright © 2018 Kenan Atmaca. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    let skView:SKView = {
       let view = SKView()
       view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(skView)
        
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        skView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let scene = MenuScene(size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}



