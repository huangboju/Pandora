//
//  ViewController.swift
//  Cards
//
//  Created by Paolo on 05/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data source for CardGroupSliding
        let icons: [UIImage] = [
            
            UIImage(named: "grBackground")!,
            UIImage(named: "background")!,
            UIImage(named: "flappy")!,
            UIImage(named: "flBackground")!,
            UIImage(named: "Icon")!,
            UIImage(named: "mvBackground")!
            
        ]
        
        let card = CardGroupSliding(frame: CGRect(x: 15, y: 50, width: view.frame.width - 30 , height: 360))
        card.textColor = UIColor.black
        
        card.icons = icons
        card.iconsSize = 60
        card.iconsRadius = 30
        
        card.title = "from the editors"
        card.subtitle = "Welcome to XI Cards !"
        
        
        view.addSubview(card)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("aaa")
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
}


