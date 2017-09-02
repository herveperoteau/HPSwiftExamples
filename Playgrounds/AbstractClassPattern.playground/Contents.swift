//: Playground - AbstractClass solution 1
// Mettre les class dans un meme fichier en mettant l'init le la class abstraite en fileprivate
// Mais c'est quand meme limité comme solution

import UIKit
import Foundation

let ferrariF50Characteristic = VehiculeCharacteristics(enginePower: 1000,
                                                       weight: 1000,
                                                       aerodynamicLevel: 5,
                                                       brakeLevel: 5,
                                                       suspensionLevel: 6)

print(ferrariF50Characteristic)

let tiguanCharacteristic = VehiculeCharacteristics(enginePower: 200,
                                                       weight: 1300,
                                                       aerodynamicLevel: 1,
                                                       brakeLevel: 3,
                                                       suspensionLevel: 2)

print(tiguanCharacteristic)


let ferrariF50 = SportCar(name: "Ferrari-F50",
                          model3D: "Ferrari-F50",
                          characteristics: ferrariF50Characteristic)

ferrariF50.animate()


