import Foundation

class SUVCar : AbstractCar {
    
    override func willMove() {
        print("SUV prepare for move")
    }
    
    override func didMoved() {
        print("SUV move ended")
    }
    
    override func execMove() {
        super.execMove()
        print("SUV specific code for execMove \(name)")
    }
}
