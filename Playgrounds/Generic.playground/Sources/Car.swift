import Foundation

class AbstractCar : Car {
    func animate() {
        print ("AbstractCar animate")
    }
}

class SportCar : AbstractCar {
    override func animate() {
        super.animate()
        print ("Specific SportCar animate")
    }
}

class SUVCar : AbstractCar {
    override func animate() {
        super.animate()
        print ("Specific SUV animate")
    }
}
