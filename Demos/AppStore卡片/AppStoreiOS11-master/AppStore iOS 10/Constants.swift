//
//  Constants.swift
//  AppStore iOS 10
//
//  Created by Abdul-Mujeeb Aliu on 7/2/17.
//  Copyright © 2017 Abdul-Mujeeb Aliu. All rights reserved.
//

import Foundation


let API_KEY = "NoYH8D-L1B7-mR1dxWPYO2eCBF0"

let BASE_URL = "https://api.apptweak.com/ios"
let ARGUMENTS = "&country=us&language=us&device=iphone"
let SEARCH_PATH = "/searches.json?term="

let DETAILS_PATH = "/applications/"
let FORMAT = ".json?"

func getSearchURLForQuery(query: String) -> String {
    let searchURL = "\(BASE_URL)\(SEARCH_PATH)\(query)\(ARGUMENTS)"
    return searchURL
}

typealias Completed = (_ data : [App]) -> ()

func getDetailsURLForID(appID: Int) -> String {
    let searchURL = "\(BASE_URL)\(DETAILS_PATH)\(appID)\(FORMAT)\(ARGUMENTS)"
    return searchURL
}
