//
//  Category.swift
//  ToDoey
//
//  Created by Morten Albertsen on 17/07/2018.
//  Copyright © 2018 Morten Albertsen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
