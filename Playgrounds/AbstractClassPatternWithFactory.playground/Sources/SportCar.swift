import Foundation

class SportCar : AbstractCar {
    
    override func willMove() {
        print("SportCar prepare for move")
    }

    override func didMoved() {
        print("SportCar move ended")
    }
    
    override func execMove() {
        super.execMove()
        print("SportCar specific code execMove \(name)")
    }
}
