//
//  ViewController.swift
//  AnimatedPageView
//
//  Created by Alex K. on 12/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var onboarding: PaperOnboarding!
  @IBOutlet weak var skipButton: UIButton!
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    skipButton.hidden = true
    
    // EXAMPLE USE FROM CODE
    
//    let onboarding = PaperOnboarding(itemsCount: 3)
//    onboarding.dataSource = self
//    onboarding.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(onboarding)
//    
//    // add constraints
//    for attribute: NSLayoutAttribute in [.Left, .Right, .Top, .Bottom] {
//      let constraint = NSLayoutConstraint(item: onboarding,
//                                          attribute: attribute,
//                                          relatedBy: .Equal,
//                                          toItem: view,
//                                          attribute: attribute,
//                                          multiplier: 1,
//                                          constant: 0)
//      view.addConstraint(constraint)
//    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func buttnoHandler(sender: AnyObject) {
  }
}

// MARK: Actions

extension ViewController {
  
  @IBAction func buttonHandler(sender: AnyObject) {
    print("skip handler")
  }
}

extension ViewController: PaperOnboardingDelegate {
  
  func onboardingWillTransitonToIndex(index: Int) {
    skipButton.hidden = index == 2 ? false : true
  }
  
  func onboardingDidTransitonToIndex(index: Int) {
    
  }
  
  func onboardingConfigurationItem(item: OnboardingContentViewItem, index: Int) {
    
//    item.titleLabel?.backgroundColor = .redColor()
//    item.descriptionLabel?.backgroundColor = .redColor()
//    item.imageView = ...
  }
}

// MARK: PaperOnboardingDataSource

extension ViewController: PaperOnboardingDataSource {
  
  func onboardingItemAtIndex(index: Int) -> OnboardingItemInfo {
    let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFontOfSize(36.0)
    let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFontOfSize(14.0)
    return [
      (UIImage.Asset.Hotels.rawValue, "Hotels", "All hotels and hostels are sorted by hospitality rating", UIImage.Asset.Key.rawValue, UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00), UIColor.whiteColor(), UIColor.whiteColor(), titleFont,descriptionFont),
      (UIImage.Asset.Banks.rawValue, "Banks", "We carefully verify all banks before add them into the app", UIImage.Asset.Wallet.rawValue, UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00), UIColor.whiteColor(), UIColor.whiteColor(), titleFont,descriptionFont),
      (UIImage.Asset.Stores.rawValue, "Stores", "All local stores are categorized for your convenience", UIImage.Asset.Shopping_Cart.rawValue, UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00), UIColor.whiteColor(), UIColor.whiteColor(), titleFont,descriptionFont)
    ][index]
  }
  
  func onboardingItemsCount() -> Int {
    return 3
  }
}