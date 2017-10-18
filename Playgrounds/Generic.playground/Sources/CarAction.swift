import Foundation

public func moveCar(_ car: Car) {
    print ("common code : prepare car ...")
    car.animate()
    print ("common code : stop car.")
}


public func someFunction<T: Car>(someT: T) {
    someT.animate()
}

