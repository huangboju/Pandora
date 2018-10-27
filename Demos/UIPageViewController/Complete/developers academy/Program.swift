//
//  Program.swift
//  Developers Academy
//
//  Created by Duc Tran on 11/27/15.
//  Copyright © 2015 Developers Academy. All rights reserved.
//

import UIKit

class Program {
    var title = ""
    var description = ""
    var image = UIImage(named: "1")
    var url = ""
    var courses = [Course]()
    
    init(title: String, description: String, image: UIImage, url: String, courses: [Course])
    {
        self.title = title
        self.description = description
        self.image = image
        self.url = url
        self.courses = courses
    }
    
    static func TotalIOSBlueprint() -> Program
    {
        let course1 = Course(title: "1. Master the Swift Programming Language", description: "Everything you need to learn about Swift to get up and running with iOS Development", image: UIImage(named: "1")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course2 = Course(title: "2. Build Motivational Random Quotes App", description: "Start iOS Development Dive-Deep Training By Building Your First iOS App!", image: UIImage(named: "2")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course3 = Course(title: "3. Build Music Playlist App", description: "We All Love Music. Let's Build A Breath-Takingly Beautiful Music Playlist App.", image: UIImage(named: "3")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course4 = Course(title: "4. Optionals in Swift", description: "Everything you need to know do create, use and handle Optional in Swift.", image: UIImage(named: "4")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course5 = Course(title: "5. Build Tip Calculator App", description: "Learn So Much More About iOS: Text Field, Slider, Delegate Methods, UIControl Events and UILabel.", image: UIImage(named: "5")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course6 = Course(title: "6. All Things Auto Layout", description: "How to Build Universal Apps That Fits All Screen Sizes", image: UIImage(named: "6")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course7 = Course(title: "7. Create and Customize UI Controls in iOS", description: "WebKit, UIWebView, UISlider, Date Picker, Picker View, Scroll View, Alert View, UISwitch, Slider, UISegmentedControl and much more...", image: UIImage(named: "7")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course8 = Course(title: "8. All Things UITableView", description: "Everything You Need to Know To Master UITableView. Learn to Use UITableView, UITableViewController, Delete Rows, Multiple Sections, Custom Cell, Static Cells.", image: UIImage(named: "8")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course9 = Course(title: "9. Build Twitter Client App", description: "Diving Deep Into UITableView, TextField Delegate, Multi-threading, NSDateFormatter, Attributed String and More.", image: UIImage(named: "9")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course10 = Course(title: "10. All Things Collection View", description: "Create a news reader app with UICollectionView. Everything you need to know to master UICollectionViewController to create customized layout in iOS.", image: UIImage(named:"10")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course11 = Course(title: "11. REST API: Build a Photos Browser App", description: "Use Instagram REST API, process JSON, practice with UICollectionView and UITableView, master iOS Networking and Multithreading.", image: UIImage(named: "11")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course12 = Course(title: "12. How to Build Instagram Fetcher App Pt 2", description: "Use Instagram API to download data in JSON format. Parse JSON, Advanced UITableView, Advanced iOS Networking and UICollectionView.", image: UIImage(named: "12")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course18 = Course(title: "18. How to Monetize Your Apps", description: "How to Package, Publish, Market, and Monetize Your Wonderful Apps", image: UIImage(named: "18")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let course19 = Course(title: "19. Code Hangout With Duc", description: "Hangout on air every Saturday at 9AM CDT with me, talking Swift and best iOS practices.", image: UIImage(named: "19")!, programURL: "http://learn.developersacademy.io/courses/total-ios-blueprint")
        
        let courses = [course1, course2, course3, course4, course5, course6, course7, course8, course9, course10, course11, course12, course18, course19]
        let totaliOSBlueprint = Program(title: "Total iOS Blueprint", description: "Everything you need to develop iOS Apps. No experience required. Build more than 70 projects in your portfolio.", image: UIImage(named: "tib")!, url: "https://developersacademy.squarespace.com/black-friday-surprise-tib", courses: courses)
        
        return totaliOSBlueprint
    }
    
    static func SocializeYourApps() -> Program
    {
        let course12 = Course(title: "12. How to Build Instagram Fetcher App Pt 2", description: "Use Instagram API to download data in JSON format. Parse JSON, Advanced UITableView, Advanced iOS Networking and UICollectionView.", image: UIImage(named: "12")!, programURL: "http://learn.developersacademy.io/courses/socialize-your-apps-online")
        
        let course13 = Course(title: "13. Design iOS Apps in Sketch", description: "Design iOS Apps in Sketch For The Rest of Us", image: UIImage(named: "13")!, programURL: "http://learn.developersacademy.io/courses/socialize-your-apps-online")
        
        let course14 = Course(title: "14. Prototype iOS Apps with Flinto", description: "Fake it Til' You Make It. Make Prototypes for Your Apps Now!", image: UIImage(named: "14")!, programURL: "http://learn.developersacademy.io/courses/socialize-your-apps-online")
        
        let course15 = Course(title: "15. Build Snapchat Clone wt Parse", description: "Create self-destructive photo and video messaging app like Snapchat. Learn Parse, Instant Messaging and Push Notification", image: UIImage(named: "15")!, programURL: "http://learn.developersacademy.io/courses/socialize-your-apps-online")
        
        let course16 = Course(title: "16. PARSE: Build Social Networking App (like Facebook, Instagram)", description: "Learn iOS Animations, Parse, Table View, Scroll View, and Build Social Networking App!", image: UIImage(named: "16")!, programURL: "http://learn.developersacademy.io/courses/socialize-your-apps-online")
        
        let course17 = Course(title: "17. PARSE: Build Instant Messaging App (like iMessage, Facebook Messenger)", description: "Learn Parse, Customized UI, iOS Animation, Build an App like iMessage and Facebook Messenger", image: UIImage(named: "17")!, programURL: "http://learn.developersacademy.io/courses/socialize-your-apps-online")
        
        let course18 = Course(title: "18. How to Monetize Your Apps", description: "How to Package, Publish, Market, and Monetize Your Wonderful Apps", image: UIImage(named: "18")!, programURL: "http://learn.developersacademy.io/courses/socialize-your-apps-online")
        
        let course19 = Course(title: "19. Code Hangout With Duc", description: "Hangout on air every Saturday at 9AM CDT with me, talking Swift and best iOS practices.", image: UIImage(named: "19")!, programURL: "http://learn.developersacademy.io/courses/socialize-your-apps-online")
        
        
        let courses = [course12, course13, course14, course15, course16, course17, course18, course19]
        let socializeYourApps = Program(title: "Socialize Your Apps", description: "iOS Design, Prototype, Animation and Social Network Apps Development wt Parse. Duc's Live Coaching Weekly.", image: UIImage(named: "sya")!, url: "http://developersacademy.squarespace.com/black-friday-sya", courses: courses)
        
        return socializeYourApps
    }
}















