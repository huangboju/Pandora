//
//  ToDoStore.swift
//  Reducer
//
//  Created by 黄伯驹 on 2017/8/19.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import Foundation

let dummy = [
    "Buy the milk",
    "Take my dog",
    "Rent a car"
]

struct ToDoStore {
    static let shared = ToDoStore()
    func getToDoItems(completionHandler: (([String]) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler?(dummy)
        }
    }
}
