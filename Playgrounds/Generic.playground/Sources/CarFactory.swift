import Foundation

public protocol Car {
    func animate()
}

public enum CarType {
    case sport
    case suv
}

public class CarFactory {
    public static func createCar(type: CarType) -> Car {
        switch (type) {
        case .sport:
            return SportCar()
        case .suv:
            return SUVCar()
        }
    }
}
