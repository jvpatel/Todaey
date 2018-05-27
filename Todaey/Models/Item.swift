//
//  Item.swift
//  Todaey
//
//  Created by Jay on 5/27/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import Foundation

//all properties must be standard, else all should be encodable
//allows to write in different format
//class Item : Encodable, Decodable {
class Item : Codable {
    var title : String = ""
    var done : Bool = false //by default taak isn't completed
}
