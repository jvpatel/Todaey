//
//  Item.swift
//  Todaey
//
//  Created by Jay on 5/28/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    // MARK: - Properties
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // MARK: - Relationships
    
    //Backward relationship - inverse relationship (1-1)
    //Category.self: means it is a type, just Category is a class, type is "object.type"
    //property is name of relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
