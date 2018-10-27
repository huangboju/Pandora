//
//  Course.swift
//  Developers Academy
//
//  Created by Duc Tran on 11/27/15.
//  Copyright © 2015 Developers Academy. All rights reserved.
//

import UIKit

class Course
{
    var title = ""
    var description = ""
    var image: UIImage!
    var programURL = ""
    
    init(title: String, description: String, image: UIImage, programURL: String)
    {
        self.title = title
        self.description = description
        self.image = image
        self.programURL = programURL
    }
}
