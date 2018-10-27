//
//  FirstCollectionViewController.swift
//  WBWaterfallFlow
//
//  Created by caowenbo on 16/2/20.
//  Copyright © 2016年 曹文博. All rights reserved.
//

import UIKit

class FirstCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(collectionView)
    }

    // MARK: - lazy loading
    private lazy var collectionView: UICollectionView = {

        let layout = FirstLayout()

        layout.itemSize = CGSize(width: 180, height: 180)

        let frame = CGRectMake(0, (KScreenHeight - 200) / 2, KScreenWidth, 200)

        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.registerNib(UINib.init(nibName: String(FirstCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: String(FirstCollectionViewCell))

        return collectionView
    }()
}

// MARK: - UICollectionViewDataSource
extension FirstCollectionViewController: UICollectionViewDataSource {

    func collectionView(collectionView _: UICollectionView, numberOfItemsInSection _: Int) -> Int {

        return 20
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(FirstCollectionViewCell), forIndexPath: indexPath) as! FirstCollectionViewCell

        cell.name = String(indexPath.row + 1)

        return cell
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
