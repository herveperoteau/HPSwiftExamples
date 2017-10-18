import Foundation

public protocol VehiculeAnimatable {
    func animate()
}

public enum CarType {
    case sport
    case suv
}

public class CarFactory {
    static public func createCar(type: CarType, name: String, model3D: String) -> VehiculeAnimatable {
        switch type {
        case .sport:
            let car = SportCar()
            car.setup(name: name, model3D: model3D)
            return car
        case .suv:
            let car = SUVCar()
            car.setup(name: name, model3D: model3D)
            return car
        }
    }
}
