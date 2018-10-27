//
//  SPPageItemsScallingViewController.swift
//  createBageCollectionView
//
//  Created by Ivan Vorobei on 9/7/16.
//  Copyright © 2016 Ivan Vorobei. All rights reserved.
//

import UIKit

class SPPageItemsScallingViewController: SPGradientViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView = SPPageItemsScalingCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.view.addSubview(self.collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.5)
        self.collectionView.center = self.view.center
    }
    
    //MARK: - UICollectionViewDataSource
    //must ovveride in subclass
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("need emplementation in subclass")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("need emplementation in subclass")
    }
    
    //MARK: - UICollectionViewDelegate
    //Centering first and last item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let width = self.collectionView.frame.width
        let itemWidth = self.collectionView.layout.itemSize.width
        let edgeInsets = (width - itemWidth) / 2
        return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
    }
}
