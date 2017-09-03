//: Playground - noun: a place where people can play

import UIKit

// A ben non, ca utilise pas des generic !!
let ferrari = CarFactory.createCar(type: .sport)
moveCar(ferrari)

let suv = CarFactory.createCar(type: .suv)
moveCar(suv)

// Et la en generic (type constraint) ca marche pas :-(
//someFunction(someT: suv)

