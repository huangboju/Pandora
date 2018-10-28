//
//  Utils.swift
//  AppStore iOS 10
//
//  Created by Abdul-Mujeeb Aliu on 7/2/17.
//  Copyright © 2017 Abdul-Mujeeb Aliu. All rights reserved.
//

import UIKit


func getAttributedStringForDesc(app : App) -> NSAttributedString {
    let lightGray = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 2
    
    var attributedString = NSMutableAttributedString()
    
    if let appName = app.appName{
        attributedString = NSMutableAttributedString(string: "\(appName)\n".capitalized, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    if let appDesc = app.appDesc, let appCateg = app.appCategory{
        attributedString.append(NSAttributedString(string: "\(appDesc)\n\(appCateg)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: lightGray]))
    }
    
    return attributedString
}


func getAttributedStringForDescDetail(app : App) -> NSAttributedString {
    let lightGray = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 2
    
    var attributedString = NSMutableAttributedString()
    
    if let appName = app.appName{
        attributedString = NSMutableAttributedString(string: "\(appName)\n".capitalized, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    let range = NSMakeRange(0, attributedString.string.count)
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
    
    if let appDesc = app.appDesc, let appCateg = app.appCategory{
        attributedString.append(NSAttributedString(string: "\(appDesc)\n\(appCateg)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: lightGray]))
    }
    
    return attributedString
}
