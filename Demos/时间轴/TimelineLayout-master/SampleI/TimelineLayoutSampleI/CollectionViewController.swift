//
//  CollectionViewController.swift
//  LayoutAnimationSample
//
//  Created by seedante on 15/11/10.
//  Copyright © 2015年 seedante. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var itemCountInSection: [Int] = [4, 5, 8]

    override func viewDidLoad() {
        super.viewDidLoad()

        let insertItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CollectionViewController.insertItem))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(CollectionViewController.deleteItem))
        let insertSectionItem = UIBarButtonItem(title: "Add Section", style: .plain, target: self, action: #selector(CollectionViewController.insertSection))
        let deleteSectionItem = UIBarButtonItem(title: "Delete Section", style: .plain, target: self, action: #selector(CollectionViewController.deleteSection))
        self.navigationItem.rightBarButtonItems = [deleteSectionItem, insertSectionItem, deleteItem, insertItem]
    }

    func insertItem(){
        guard itemCountInSection.count > 0 else{
            return
        }
        let sectionCount = itemCountInSection.count
        let randomSection = Int(arc4random_uniform(UInt32(sectionCount)))
        let previousCount = itemCountInSection[randomSection]
        itemCountInSection[randomSection] = previousCount + 1
        let randomItem = Int(arc4random_uniform(UInt32(previousCount)))
        self.collectionView?.insertItems(at: [IndexPath(item: randomItem, section: randomSection)])
    }

    func deleteItem(){
        guard itemCountInSection.count > 0 else{
            return
        }
        let sectionCount = itemCountInSection.count
        let randomSection = Int(arc4random_uniform(UInt32(sectionCount)))
        let previousCount = itemCountInSection[randomSection]
        if previousCount > 0{
            let randomItem = Int(arc4random_uniform(UInt32(previousCount)))
            let deletedIndexPath = IndexPath(item: randomItem, section: randomSection)
            self.itemCountInSection[randomSection] = previousCount - 1
            self.collectionView?.deleteItems(at: [deletedIndexPath])
        }else{
            print("Empty Section, Try again.")
        }
    }

    func insertSection(){
        let randomCount = Int(arc4random_uniform(UInt32(5))) + 1
        itemCountInSection.insert(randomCount, at: 0)
        self.collectionView?.insertSections(IndexSet(integer: 0))
    }

    func deleteSection(){
        if itemCountInSection.count > 0{
            itemCountInSection.removeFirst()
            self.collectionView?.deleteSections(IndexSet(integer: 0))
        }
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return itemCountInSection.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemCountInSection[section]
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        if let imageView = cell.viewWithTag(10) as? UIImageView{

            let Number1 = Int(arc4random_uniform(UInt32(2)))
            let Number2 = Int(arc4random_uniform(UInt32(10)))
            let imageName = "\(Number1)\(Number2).png"
            imageView.image = UIImage(named: imageName)
        }
        return cell
    }


    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var supplementaryView: UICollectionReusableView
        if kind == UICollectionElementKindSectionHeader{
            supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            if let textLabel = supplementaryView.viewWithTag(10) as? UILabel{
                switch indexPath.section{
                case 0:
                    textLabel.text = "Novermber 2015"
                case 1:
                    textLabel.text = "October 2015"
                case 2:
                    textLabel.text = "September 2015"
                case 3:
                    textLabel.text = "August 2015"
                default:
                    textLabel.text = "Early 2015"
                }
            }
        }
        else{
            supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
        }

        return supplementaryView
    }


    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == itemCountInSection.count - 1{
            return CGSize(width: 50, height: 2)
        }else{
            return CGSize.zero
        }
    }
}
