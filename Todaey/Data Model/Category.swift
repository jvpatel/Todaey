//
//  Category.swift
//  Todaey
//
//  Created by Jay on 5/28/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    // MARK: - Properties
    @objc dynamic var name : String = ""
    
    // MARK: - Relationships
    
    //forward relationship
    let items = List<Item>() //empty list, one to many
    //let array : [INT] or [1,2,3] or Array<Int> = [1,2,3] or Array<Int>() - ways to create array
}
