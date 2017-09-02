import Foundation

import UIKit
import Foundation

public protocol VehiculeCharacteristicsProtocol: CustomDebugStringConvertible {

    var enginePower: Int { get }
    var weight: Int { get }
    var aerodynamicLevel: Int { get }
    var brakeLevel: Int { get }
    var suspensionLevel: Int { get }
}

public struct VehiculeCharacteristics : VehiculeCharacteristicsProtocol {

    public let enginePower: Int
    public let weight: Int
    public let aerodynamicLevel: Int
    public let brakeLevel: Int
    public let suspensionLevel: Int
    
    public var debugDescription: String {
        get {
            return "power:\(enginePower), weight:\(weight), aero:\(aerodynamicLevel), brake:\(brakeLevel), suspension:\(suspensionLevel)"
        }
    }
    
    public init(enginePower: Int, weight: Int, aerodynamicLevel: Int, brakeLevel: Int, suspensionLevel: Int) {
        self.enginePower = enginePower
        self.weight = weight
        self.aerodynamicLevel = aerodynamicLevel
        self.brakeLevel = brakeLevel
        self.suspensionLevel = suspensionLevel
    }
}

public class CarAbstract {
    
    let name:String
    let model3D: String
    let characteristics:VehiculeCharacteristicsProtocol

    // private because Abstract
    fileprivate init(name:String, model3D: String, characteristics: VehiculeCharacteristicsProtocol) {
        self.name = name
        self.model3D = model3D
        self.characteristics = characteristics
    }
    
    func animate() {
        print("CarAbstract animate \(name) ...")
    }
}

public class SportCar: CarAbstract {
    
    public override init(name:String, model3D: String, characteristics: VehiculeCharacteristicsProtocol) {
        super.init(name: name, model3D: model3D, characteristics: characteristics)
    }

    override public func animate() {
        super.animate()
        print("SportCar animate \(name) ...")
    }
}

class SUV: CarAbstract {
    
    public override init(name:String, model3D: String, characteristics: VehiculeCharacteristicsProtocol) {
        super.init(name: name, model3D: model3D, characteristics: characteristics)
    }
    
    override public func animate() {
        super.animate()
        print("SUV animate \(name) ...")
    }
}




