//
//  ScreenShotsHolderCell.swift
//  AppStore iOS 10
//
//  Created by Abdul-Mujeeb Aliu on 7/2/17.
//  Copyright © 2017 Abdul-Mujeeb Aliu. All rights reserved.
//

import UIKit

class ScreenShotsHolderCell: UICollectionViewCell , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    var screenShotURLS : [String]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var collectionView : UICollectionView = {
        let layout = SnappingCollectionViewLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.decelerationRate = UIScrollViewDecelerationRateFast
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
    
    var divider : UIView = {
        let divi = UIView()
        divi.backgroundColor = .lightGray
        return divi
    }()
    
    var iPadImage : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "ipad")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var iPadAppsLabl : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        let lightGray = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        label.textColor = lightGray
        label.text = "Offers iPad App"
        return label
    }()
    
    
    override func layoutSubviews() {
        addSubview(collectionView)
        addSubview(iPadAppsLabl)
        addSubview(divider)
        addSubview(iPadImage)
        
        collectionView.anchor(topAnchor, left: leftAnchor, bottom: iPadAppsLabl.topAnchor, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 14, 0, 14)
        
        iPadImage.anchor(nil, left: leftAnchor, bottom: divider.topAnchor, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 10, heightConstant: 20)
        
        iPadAppsLabl.anchor(nil, left: iPadImage.rightAnchor, bottom: divider.topAnchor, right: rightAnchor, topConstant: 16, leftConstant: 8, bottomConstant: 12, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        divider.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ScreenShotViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = screenShotURLS?.count{
            return count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.section == 0){
            return CGSize(width: collectionView.frame.width / 1.5, height: 300)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ScreenShotViewCell{
            cell.imgURL = screenShotURLS?[indexPath.item]
            return cell
        }
        
        return UICollectionViewCell() //Force a crash
    }
    
    
    
}
