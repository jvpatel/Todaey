//
//  Notes.swift
//  Todaey
//
//  Created by Jay on 5/27/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import Foundation
import UIKit

//it's singleton, all classes can use it and all gets same data
let defaults = UserDefaults.standard

func foo() {
    //what stuff can we set in defaults
    defaults.set(0.24, forKey: "Volume") //volume you had for app
    //let volume = defaults.float(forKey: "Volume")
    //let array = [1,2,3]

    defaults.set(true, forKey: "MusicOn")
    defaults.set(Date(), forKey: "AppLastOpenByUser")
    //let appOpen = defaults.object(forKey: "AppLastOpenByUser")
    //defaults.array(forkey: "myArray")
    //use defaults only to save few kb of data, we don't want to save too much data
    //don't use it as database, all gets loaded up syncly, even before anything, it takes too long to load entire plist, so have only few kb of data
}

class Car {
    var color = "Red"
}

class newCar {
    static let singletonCar = Car()
}

func Singleton() {
    //have only 1 property shared by all classes
    //let myCar = Car()
    let mycAr1 = newCar.singletonCar
    mycAr1.color = "BLue"
    print(mycAr1.color) //blue
}
