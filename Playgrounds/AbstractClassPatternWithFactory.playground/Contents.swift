//: Playground - noun: a place where people can play

import UIKit

let ferrari = CarFactory.createCar(type: .sport, name: "Ferrari", model3D: "ferrari3D")
let tiguan = CarFactory.createCar(type: .suv, name: "Tiguan", model3D: "tiguan3D")

ferrari.animate()
tiguan.animate()
